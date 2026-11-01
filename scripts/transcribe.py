"""Transcribe lecture audio with resumable, overlapping SpeechKit requests."""

# ruff: noqa: INP001

import argparse
import base64
import concurrent.futures
import hashlib
import io
import json
import logging
import sys
import time
import urllib.error
import urllib.request
import wave
from pathlib import Path
from typing import TYPE_CHECKING, NotRequired, TypedDict, cast

if TYPE_CHECKING:
    from http.client import HTTPResponse

API = "https://stt.api.cloud.yandex.net/stt/v3"
MODEL = {
    "model": "general",
    "audioFormat": {"containerAudio": {"containerAudioType": "WAV"}},
    "languageRestriction": {"restrictionType": "WHITELIST", "languageCode": ["ru-RU"]},
    "textNormalization": {
        "textNormalization": "TEXT_NORMALIZATION_DISABLED",
        "literatureText": False,
        "profanityFilter": False,
    },
}
MAX_BODY = 55_000_000
MAX_WORKERS = 4
SAMPLE_BYTES = 2
TIMING_TOLERANCE = 2
TEXT_BLOCK_SECONDS = 30
_logger = logging.getLogger(__name__)


class _Chunk(TypedDict):
    index: int
    start_frame: int
    frames: int
    start: float
    end: float


class _Word(TypedDict):
    text: str
    start: float
    end: float


class _RecognizedWord(TypedDict):
    text: str
    startTimeMs: str
    endTimeMs: str


class _Alternative(TypedDict):
    words: list[_RecognizedWord]


class _Final(TypedDict):
    alternatives: list[_Alternative]


class _Event(TypedDict):
    result: NotRequired[_Event]
    final: NotRequired[_Final]
    error: NotRequired[object]


class _Operation(TypedDict):
    id: str
    done: NotRequired[bool]
    error: NotRequired[object]


class _Arguments(argparse.Namespace):
    audio: Path
    output: Path
    key_file: Path
    folder_id: str
    chunk_seconds: int
    overlap_seconds: int
    workers: int


def _save(path: Path, text: str) -> None:
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(text, encoding="utf-8")
    temporary.replace(path)


def _request(url: str, headers: dict[str, str], payload: bytes | None = None) -> str:
    req = urllib.request.Request(url, data=payload, headers=headers)  # noqa: S310 -- Callers use fixed HTTPS endpoints.
    try:
        with cast(
            "HTTPResponse",
            urllib.request.urlopen(req, timeout=180),  # noqa: S310 -- The request uses a fixed HTTPS endpoint.
        ) as response:
            return response.read().decode("utf-8")
    except urllib.error.HTTPError as error:
        message = f"HTTP {error.code}: {error.read().decode('utf-8')}"
        raise RuntimeError(message) from None


def _recognize(audio: Path, output: Path, chunk: _Chunk, headers: dict[str, str]) -> Path:
    stem = output / f"chunk-{chunk['index']:03d}"
    raw = stem.with_suffix(".jsonl")
    operation = stem.with_suffix(".operation.json")
    if raw.exists():
        return raw
    if operation.exists():
        operation_id = cast("_Operation", json.loads(operation.read_text()))["id"]
    else:
        with wave.open(str(audio), "rb") as source:
            source.setpos(chunk["start_frame"])
            buffer = io.BytesIO()
            with wave.open(buffer, "wb") as target:
                target.setparams(source.getparams())
                target.writeframes(source.readframes(chunk["frames"]))
        payload = json.dumps(
            {
                "content": base64.b64encode(buffer.getvalue()).decode("ascii"),
                "recognitionModel": MODEL,
            }
        ).encode("utf-8")
        if len(payload) > MAX_BODY:
            message = "Encoded request exceeds the upload budget"
            raise ValueError(message)
        result = _request(f"{API}/recognizeFileAsync", headers, payload)
        operation_id = cast("_Operation", json.loads(result))["id"]
        _save(operation, result)
        _logger.info("Chunk %s: submitted %s", chunk["index"], operation_id)
    while True:
        status = cast(
            "_Operation",
            json.loads(_request(f"https://operation.api.cloud.yandex.net/operations/{operation_id}", headers)),
        )
        if "error" in status:
            raise RuntimeError(status["error"])
        if status.get("done"):
            break
        time.sleep(15)
    result = _request(f"{API}/getRecognition?operation_id={operation_id}", headers)
    for line in result.splitlines():
        event = cast("_Event", json.loads(line))
        if "error" in event:
            raise RuntimeError(event["error"])
    _save(raw, result)
    _logger.info("Chunk %s: saved", chunk["index"])
    return raw


def _words_from_result(path: Path, offset: float) -> list[_Word]:
    words: list[_Word] = []
    for line in path.read_text().splitlines():
        event = cast("_Event", json.loads(line))
        event = event.get("result", event)
        if "final" not in event:
            continue
        alternative = event["final"]["alternatives"][0]
        words.extend(
            {
                "text": word["text"],
                "start": offset + int(word["startTimeMs"]) / 1000,
                "end": offset + int(word["endTimeMs"]) / 1000,
            }
            for word in alternative["words"]
        )
    return words


def _find_overlap(merged: list[_Word], words: list[_Word], chunk: _Chunk) -> tuple[int, int]:
    overlap_end = min(merged[-1]["end"], chunk["end"])
    middle = (chunk["start"] + overlap_end) / 2
    candidates = []
    for i in range(max(0, len(merged) - 100), len(merged) - 2):
        if merged[i]["start"] < chunk["start"]:
            continue
        for j in range(min(100, max(0, len(words) - 2))):
            if abs(merged[i]["start"] - words[j]["start"]) > TIMING_TOLERANCE:
                continue
            left = [w["text"].casefold() for w in merged[i : i + 3]]
            right = [w["text"].casefold() for w in words[j : j + 3]]
            if left == right:
                candidates.append((abs(words[j]["start"] - middle), i, j))
    if candidates:
        _, i, j = min(candidates)
        return i, j
    message = f"Cannot align overlap before chunk {chunk['index']}; inspect raw results before merging"
    raise ValueError(message)


def _merge_words(chunks: list[_Chunk], results: list[list[_Word]]) -> list[_Word]:
    merged: list[_Word] = []
    for chunk, words in zip(chunks, results, strict=False):
        if not merged or not words:
            merged.extend(words)
            continue
        if merged[-1]["end"] <= chunk["start"]:
            merged.extend(words)
            continue
        i, j = _find_overlap(merged, words, chunk)
        merged = merged[:i] + words[j:]
    return merged


def _timestamp(seconds: float) -> str:
    seconds = int(seconds)
    return f"{seconds // 3600:02}:{seconds // 60 % 60:02}:{seconds % 60:02}"


def _prepare_inputs() -> tuple[_Arguments, float, list[_Chunk]]:
    parser = argparse.ArgumentParser(description="Transcribe mono PCM WAV with Yandex SpeechKit v3.")
    parser.add_argument("audio", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--key-file", type=Path, required=True)
    parser.add_argument("--folder-id", required=True)
    parser.add_argument("--chunk-seconds", type=int, default=900)
    parser.add_argument("--overlap-seconds", type=int, default=10)
    parser.add_argument("--workers", type=int, default=4)
    args = parser.parse_args(namespace=_Arguments())
    if not 1 <= args.workers <= MAX_WORKERS:
        parser.error("workers must be between 1 and 4")
    with wave.open(str(args.audio), "rb") as audio:
        rate, frames = audio.getframerate(), audio.getnframes()
        if audio.getnchannels() != 1 or audio.getsampwidth() != SAMPLE_BYTES:
            parser.error("audio must be mono 16-bit PCM WAV")
        if not frames:
            parser.error("audio must not be empty")
    chunk_seconds = min(args.chunk_seconds, (MAX_BODY - 10000) * 3 // 4 // (rate * 2), 14400)
    if not 0 < args.overlap_seconds < chunk_seconds:
        parser.error("require 0 < overlap < chunk duration")
    chunks: list[_Chunk] = []
    start = 0
    while start < frames:
        count = min(chunk_seconds * rate, frames - start)
        chunks.append(
            {
                "index": len(chunks),
                "start_frame": start,
                "frames": count,
                "start": start / rate,
                "end": (start + count) / rate,
            }
        )
        if start + count == frames:
            break
        start += (chunk_seconds - args.overlap_seconds) * rate
    return args, frames / rate, chunks


def _prepare_output(args: _Arguments, chunks: list[_Chunk]) -> None:
    with args.audio.open("rb") as source:
        digest = hashlib.file_digest(source, "sha256").hexdigest()
    manifest = {"sha256": digest, "model": MODEL, "folder_id": args.folder_id, "chunks": chunks}
    args.output.mkdir(parents=True, exist_ok=True)
    manifest_path = args.output / "manifest.json"
    if manifest_path.exists() and json.loads(manifest_path.read_text()) != manifest:
        message = "Output belongs to different audio/settings; choose a new output directory"
        raise ValueError(message)
    _save(manifest_path, json.dumps(manifest, indent=2))


def main() -> None:
    """Transcribe the WAV selected by CLI arguments and save resumable results."""
    logging.basicConfig(level=logging.INFO, format="%(message)s", stream=sys.stdout)
    args, duration, chunks = _prepare_inputs()
    _prepare_output(args, chunks)
    headers = {
        "Authorization": f"Api-key {args.key_file.read_text().strip()}",
        "x-folder-id": args.folder_id,
        "Content-Type": "application/json",
    }
    _logger.info("%.1fs audio; %s overlapping chunks", duration, len(chunks))
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = [pool.submit(_recognize, args.audio, args.output, chunk, headers) for chunk in chunks]
        paths = [future.result() for future in futures]
    results = [_words_from_result(path, chunk["start"]) for path, chunk in zip(paths, chunks, strict=False)]
    words = _merge_words(chunks, results)
    _save(args.output / "words.json", json.dumps(words, ensure_ascii=False, indent=2))
    lines: list[str] = []
    group: list[_Word] = []
    for word in words:
        if group and word["start"] - group[0]["start"] >= TEXT_BLOCK_SECONDS:
            lines.append(f"[{_timestamp(group[0]['start'])}] " + " ".join(w["text"] for w in group))
            group = []
        group.append(word)
    if group:
        lines.append(f"[{_timestamp(group[0]['start'])}] " + " ".join(w["text"] for w in group))
    _save(args.output / "transcript.txt", "\n".join(lines) + "\n")


if __name__ == "__main__":
    main()

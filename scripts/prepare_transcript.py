#!/usr/bin/env python3
"""Convert Whisper JSON into a timestamped draft and temporary review diagnostics."""

import argparse
import json
import math
import re
import wave
from pathlib import Path
from typing import NotRequired, TypedDict, cast

SAMPLE_BYTES = 2
SAMPLE_RATE = 16000
MAX_GAP = 15
MIN_LOGPROB = -0.7
MAX_TEMPERATURE = 0.6
MAX_COMPRESSION = 2.4
MAX_NO_SPEECH = 0.6


class _Segment(TypedDict):
    start: float
    end: float
    text: str
    avg_logprob: NotRequired[float]
    compression_ratio: NotRequired[float]
    no_speech_prob: NotRequired[float]
    temperature: NotRequired[float]


class _Result(TypedDict):
    segments: list[_Segment]


class _Arguments(argparse.Namespace):
    result: Path
    audio: Path
    output: Path
    offset: float


def audio_duration(path: Path) -> float:
    """Validate extracted audio and return its duration in seconds."""
    with wave.open(str(path), "rb") as audio:
        if audio.getnchannels() != 1 or audio.getsampwidth() != SAMPLE_BYTES or audio.getframerate() != SAMPLE_RATE:
            message = "Audio must be mono, 16 kHz, 16-bit PCM WAV"
            raise ValueError(message)
        if not audio.getnframes():
            message = "Audio must not be empty"
            raise ValueError(message)
        return audio.getnframes() / audio.getframerate()


def _timestamp(seconds: float) -> str:
    seconds = int(seconds)
    return f"{seconds // 3600:02}:{seconds // 60 % 60:02}:{seconds % 60:02}"


def prepare_transcript(result: Path, audio: Path, output: Path, offset: float = 0) -> None:
    """Write a one-line-per-segment draft and flag passages requiring review without overwriting files."""
    duration = audio_duration(audio)
    if not math.isfinite(offset) or offset < 0:
        message = "Recording offset must be finite and nonnegative"
        raise ValueError(message)
    segments = cast("_Result", json.loads(result.read_text(encoding="utf-8")))["segments"]
    if not segments:
        message = "Whisper returned no transcript segments; inspect the recording and recognition log"
        raise ValueError(message)
    lines = []
    findings = []
    previous_start, previous_end, previous_text = -1.0, 0.0, ""
    for index, segment in enumerate(segments):
        start, end = segment["start"], segment["end"]
        if not math.isfinite(start) or not math.isfinite(end) or not 0 <= start <= duration or end < start:
            message = f"Invalid timestamps in segment {index}: {start}, {end}; audio duration {duration}"
            raise ValueError(message)
        text = " ".join(segment["text"].split())
        if start < previous_start or not text:
            message = f"Out-of-order or empty transcript segment {index}"
            raise ValueError(message)
        lines.append(f"{_timestamp(offset + start)} -- {text}")
        normalized = re.sub(r"\W+", " ", text.casefold()).strip()
        checks = [
            (start - previous_end > MAX_GAP, "Audio gap before this segment; check for genuine silence."),
            (start < previous_end - 0.1, "Overlapping segment timestamps."),
            (end == start, "Zero-duration segment."),
            (end > duration, "Segment end exceeds the audio duration."),
            (segment.get("avg_logprob", 0) < MIN_LOGPROB, "Low recognition confidence."),
            (segment.get("temperature", 0) >= MAX_TEMPERATURE, "High-temperature recognition fallback."),
            (segment.get("compression_ratio", 0) > MAX_COMPRESSION, "High text compression ratio."),
            (segment.get("no_speech_prob", 0) > MAX_NO_SPEECH, "High no-speech probability."),
            (bool(normalized) and normalized == previous_text, "Repetition of the previous segment."),
            (
                re.search(r"[\u3400-\u9fff\u3040-\u30ff\uac00-\ud7af]", text) is not None,
                "Unexpected script in Russian transcription.",
            ),
            (
                re.search(r"(?:\b[A-Za-z]+[ ,.!?:;'-]+){3}[A-Za-z]+\b", text) is not None,
                "Extended Latin-script phrase in Russian transcription.",
            ),
        ]
        reasons = [reason for flagged, reason in checks if flagged]
        if reasons:
            findings.append({"index": index, "start": offset + start, "end": offset + end, "reasons": reasons})
        previous_start, previous_end, previous_text = start, end, normalized
    report = {
        "duration": duration,
        "offset": offset,
        "segments": len(segments),
        "first_start": offset + segments[0]["start"],
        "last_end": offset + segments[-1]["end"],
        "trailing_gap": duration - segments[-1]["end"],
        "findings": findings,
    }
    output.mkdir(parents=True, exist_ok=True)
    transcript, review = output / "transcript.txt", output / "review.json"
    for path in (transcript, review):
        if path.exists():
            raise FileExistsError(path)
    with transcript.open("x", encoding="utf-8") as destination:
        destination.write("\n".join(lines) + "\n")
    with review.open("x", encoding="utf-8") as destination:
        json.dump(report, destination, ensure_ascii=False, indent=2)
        destination.write("\n")


def main() -> None:
    """Convert saved Whisper results without running recognition again."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("result", type=Path)
    parser.add_argument("audio", type=Path)
    parser.add_argument("output", type=Path, help="Working directory for transcript.txt and review.json")
    parser.add_argument("--offset", type=float, default=0, help="Excerpt start time in the full recording, in seconds")
    args = parser.parse_args(namespace=_Arguments())
    prepare_transcript(args.result, args.audio, args.output, args.offset)


if __name__ == "__main__":
    main()

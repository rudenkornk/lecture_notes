#!/usr/bin/env python3
"""Transcribe extracted lecture audio locally into a new temporary working directory."""

import argparse
import os
import shutil
import subprocess
from pathlib import Path

from prepare_transcript import audio_duration, prepare_transcript


class _Arguments(argparse.Namespace):
    audio: Path
    output: Path


def main() -> None:
    """Run cached large-v3 on CUDA and preserve working results until review is complete."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("audio", type=Path)
    parser.add_argument("output", type=Path, help="New working directory; existing directories are refused")
    args = parser.parse_args(namespace=_Arguments())
    audio_duration(args.audio)
    executable = shutil.which("whisper-ctranslate2")
    if executable is None:
        message = "The installed CUDA-enabled whisper-ctranslate2 is required"
        raise FileNotFoundError(message)
    args.output.mkdir(parents=True)
    raw = args.output / "raw"
    log = args.output / "recognition.log"
    command = [
        executable,
        str(args.audio),
        "--model",
        "large-v3",
        "--local_files_only",
        "True",
        "--device",
        "cuda",
        "--device_index",
        "0",
        "--compute_type",
        "int8_float16",
        "--language",
        "ru",
        "--task",
        "transcribe",
        "--batched",
        "False",
        "--beam_size",
        "1",
        "--best_of",
        "3",
        "--output_format",
        "json",
        "--output_dir",
        str(raw),
    ]
    with log.open("x", encoding="utf-8") as destination:
        subprocess.run(  # noqa: S603 -- The installed executable runs directly, without a shell.
            command,
            env=os.environ | {"HF_HUB_OFFLINE": "1", "TRANSFORMERS_OFFLINE": "1"},
            stdout=destination,
            stderr=subprocess.STDOUT,
            check=True,
        )
    errors = ("Exception Type:", "Exception Message:", "Error: Unable to process file:")
    if any(line.startswith(errors) for line in log.read_text(encoding="utf-8").splitlines()):
        message = f"Whisper reported a recognition error despite exiting successfully; inspect {log}"
        raise RuntimeError(message)
    prepare_transcript(raw / f"{args.audio.stem}.json", args.audio, args.output)


if __name__ == "__main__":
    main()

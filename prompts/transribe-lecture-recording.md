# Transcribe a complete lecture recording

Produce a verified, timestamped transcript of the provided lecture recording.
Do not summarize the lecture, write course notes, or change course entry points.

Materials directory: `<path>`.
Yandex API-key file: `<path>`.
Yandex folder ID: `<folder-id>`.

Follow repository instructions and reuse the existing transcription tooling.
You may independently choose transcription settings and routine verification steps within these requirements.
Ask about missing required inputs, substantial source ambiguities, or changes to reusable tooling.
If several recordings could be the intended lecture, clarify which one to use.

## Inspect the materials

- Inventory the recording, slides, notebooks, and other supplements.
  Confirm the lecture topic and date when available.
- Inspect the recording's duration and audio streams.
  Review supplementary materials to identify technical terminology and notation for transcript verification.
- Keep original materials unchanged.
  Store audio, raw recognition results, transcripts, previews, and processing scripts outside the repository,
  preferably in a `processed/` directory beside the materials.

## Extract and transcribe the full recording

Use the media devshell for audio extraction and transcription.

```bash
nix develop .#media
mkdir -p "<processed>"
bash scripts/extract-audio.sh "<recording>" "<processed>/lecture.wav"
python scripts/transcribe.py "<processed>/lecture.wav" "<processed>/transcription" \
    --key-file "<key-file>" --folder-id "<folder-id>"
```

- Read credentials from the supplied file; do not print them or place them in source code or commits.
- Extraction preserves recording-relative timestamps, including pauses, and produces mono, 16 kHz, 16-bit PCM WAV.
  It refuses to overwrite an existing audio file.
- Use Yandex SpeechKit asynchronous recognition with Russian recognition by default.
  Start with the script's defaults: 900-second chunks, 10-second overlaps, and four concurrent workers.
- The script uses a 55 MB encoded-request budget, below the 60 MB direct-upload limit,
  including Base64 and request overhead.
  Check the current API limits before increasing chunk sizes or concurrency.
- Reuse saved results and operation IDs when resuming instead of repeating billable submissions.
  The output directory stores the audio/settings manifest, per-chunk operation IDs, raw JSONL results,
  `words.json`, and a timestamped `transcript.txt`.
  Rerun the same command to resume; changed audio or settings require a new output directory.
  Use only one transcription process per output directory.
  Remote recognition results expire after three days; downloaded results remain reusable.
  API errors do not trigger automatic resubmission.
  If a request's outcome is uncertain, investigate before resubmitting it.
  If submission succeeded but its operation ID was not saved, inspect the cloud operation before rerunning.
- Keep normalization and literary rewriting disabled initially to preserve technical wording.
  Check the script's supported settings before deciding to change recognition behavior.

## Verify the transcript

- Verify that the chunks cover the entire audio and that merging neither duplicates nor drops boundary phrases.
  Inspect uncertain joins against raw results and the recording.
  Account for genuine silence rather than treating every transcript gap as missing recognition.
- Read the complete transcript.
  Recognition can distort technical terms, negations, numbers, and spoken formulas;
  resolve these against slides, notebook code, and the relevant recording segment.
- Write the reviewed version to `<processed>/transcript-reviewed.txt`, preserving recording-relative timestamps.
  Leave the script-generated `transcript.txt`, `words.json`, raw results, and resume metadata untouched.
- Preserve the lecture's wording, order, qualifications, examples, and discussion rather than condensing them into notes.
  Correct recognition errors only when supported by the recording and available materials.
  Do not silently repair the lecturer's mathematical claims or invent missing explanations.
- Mark unresolved readings in the reviewed transcript and report their timestamps with the remaining questions.
  Ask about substantive uncertainties rather than presenting guesses as verified text.

## Hand off and report

- Keep credentials, recordings, extracted audio, and all transcript artifacts out of Git.
- Do not change reusable tooling without approval.
  If approved changes are needed, separate mechanical preparation from tooling changes,
  run the repository checks, and fold corrections into the relevant commits from this task.
  Preserve unrelated work and do not push without an explicit request.
- Hand off the reviewed transcript and supplementary material paths for use with `typeset-lecture-transcription.md`.

Finish with the recording path and duration, extracted audio path, raw and reviewed transcript paths,
coverage and verification checks performed, unresolved uncertainties with timestamps, and any commit status.

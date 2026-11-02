# Transcribe a complete lecture recording

Produce a verified, timestamped transcript of the provided lecture recording.
Do not summarize the lecture, write course notes, or change course entry points.
After recognition and review are finished, leave only one final transcription file.

Materials directory: `<path>`.
Transcription backend: `<local|yandex>`.
Final transcript: `<path>/transcript.txt`.

Follow repository instructions and reuse the existing transcription tooling.
You may independently choose routine extraction and verification steps within these requirements.
Ask about missing required inputs, substantial source ambiguities, or changes to reusable tooling.
If several recordings could be the intended lecture, clarify which one to use.
Do not choose a backend implicitly or switch backends, models, or recognition settings without approval.

## Inspect the materials

- Inventory the recording, slides, notebooks, and other supplements.
  Confirm the lecture topic and date when available.
- Inspect the recording's duration and audio streams.
  Review supplementary materials to identify technical terminology and notation for transcript verification.
- Keep original materials and cached models unchanged.
- Keep all working data outside the repository in a private temporary directory beside the materials.
  Record its path so unfinished work can be resumed.
  The final transcript must be outside this working directory.

## Extract audio

Use the media devshell for extraction and Python helpers.
Use the installed CUDA-enabled `whisper-ctranslate2` for local recognition and the installed `sops` for cloud credentials.

```bash
nix develop .#media
work=$(mktemp -d "<materials>/.transcribe.XXXXXX")
bash scripts/extract-audio.sh "<recording>" "$work/lecture.wav"
```

- Extraction preserves recording-relative timestamps, including pauses, and produces mono, 16 kHz, 16-bit PCM WAV.
  It refuses to overwrite an existing audio file.
- Do not install an unconditional cleanup trap.
  If a command fails or the session is interrupted, retain the working directory until the run is resolved.

## Transcribe locally

Use this section only when the selected backend is `local`.

```bash
python scripts/transcribe_local.py "$work/lecture.wav" "$work/recognition"
```

- Use the cached full `large-v3` model, CUDA device 0, `int8_float16`, Russian transcription,
  no batching, `beam_size=1`, and `best_of=3`.
  The helper fixes these settings and disables model downloads.
- Test a short excerpt, including any known problematic section, in a separate working subdirectory before the full run.
  A successful short test does not guarantee that the full recording fits GPU memory.
- If the model is missing, CUDA fails, or recognition runs out of memory, stop and ask.
  Do not fall back to CPU, a smaller model, different decoding settings, or cloud recognition.
- This is a single-pass runner, not a chunked or resumable recognizer.
  It refuses an existing output directory and preserves diagnostics on failure.
  It validates recognition results rather than trusting the executable's exit status alone.
- Working outputs include `raw/lecture.json`, `recognition.log`, `transcript.txt`, and `review.json`.
  Review diagnostics flag suspicious gaps, repetition, scripts, confidence, and timestamps; they do not correct text.
  Genuine pauses and technical notation can trigger warnings without being recognition errors.

To reconvert saved JSON without recognition, or restore recording-relative timestamps for an excerpt, use:

```bash
python scripts/prepare_transcript.py "<result.json>" "<excerpt.wav>" "$work/reconverted" \
    --offset <excerpt-start-seconds>
```

## Transcribe with Yandex Cloud

Use this section only when the selected backend is `yandex`.

```bash
python scripts/transcribe.py "$work/lecture.wav" "$work/recognition" \
    --creds <(sops --decrypt ~/projects/dotfiles/nix/secrets/yacloud.sops.json)
```

- Obtain credentials using the command above instead of asking the user for an API key or folder ID.
  Pass decrypted JSON through process substitution; do not print or save plaintext credentials or enable shell tracing.
  The script reads `folder_id` and `ai_studio.api_key` without knowing about SOPS or the secrets location.
  Stop if decryption or credential loading fails; do not ask the user to paste secrets.
- Use Yandex SpeechKit asynchronous recognition with Russian recognition by default.
  Start with the script's defaults: 900-second chunks, 10-second overlaps, and four concurrent workers.
- The script uses a 55 MB encoded-request budget, below the 60 MB direct-upload limit,
  including Base64 and request overhead.
  Check the current API limits before increasing chunk sizes or concurrency.
- Reuse saved results and operation IDs when resuming instead of repeating billable submissions.
  The working output directory stores the audio/settings manifest, per-chunk operation IDs, raw JSONL results,
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

- Verify coverage of the full recording, including the beginning and end.
  For cloud recognition, check that chunks cover the entire audio and merging neither duplicates nor drops boundary phrases.
  Inspect uncertain joins, suspicious gaps, and repeated passages against raw results and the recording.
  Account for genuine silence rather than treating every transcript gap as missing recognition.
- Read the complete transcript.
  Recognition can distort technical terms, negations, numbers, and spoken formulas;
  resolve these against slides, notebook code, and the relevant recording segment.
- Use one line per segment in both backends: `HH:MM:SS -- text`.
  Put the segment's start timestamp and its text on the same line, with no subtitle headers or separate end timestamps.
- Write a reviewed draft inside the working directory, preserving recording-relative timestamps.
  Leave machine outputs and resume metadata untouched until review is complete.
- Preserve the lecture's wording, order, qualifications, examples, and discussion rather than condensing them into notes.
  Correct recognition errors only when supported by the recording and available materials.
  Do not silently repair the lecturer's mathematical claims or invent missing explanations.
- Mark unresolved readings directly in the transcript and report their timestamps with the remaining questions.
  Ask about substantive uncertainties rather than presenting guesses as verified text.
- Validate the final text's line format and that timestamps are ordered and within the recording.
  Be explicit about what was checked; text review and repeated recognition are not a word-for-word auditory verification.

## Publish and clean up

- Publish the reviewed text to the requested final transcript path outside the working directory.
  Ask before overwriting an existing file.
  Verify the published file before deleting working data.
- After recognition and polishing are complete, remove only the temporary working directory created for this task.
  Remove extracted audio, raw recognition results, operation IDs, logs, machine drafts, review reports,
  previews, excerpts, and temporary processing scripts together.
  Leave just the final transcription file alongside the unchanged original materials.
  Do not retain a separate machine transcript, uncertainty report, or other sidecar.
- If the run is unfinished, failed, or interrupted, keep working data until it is resolved.
  In particular, do not discard cloud operation IDs needed to avoid duplicate paid submissions.
  Do not delete pre-existing files, unrelated working directories, or cached models.

## Hand off and report

- Keep credentials, recordings, extracted audio, and all transcript artifacts out of Git.
- Do not change reusable tooling without approval.
  If approved changes are needed, separate mechanical preparation from tooling changes,
  run the repository checks, and fold corrections into the relevant commits from this task.
  Preserve unrelated work and do not push without an explicit request.
- Hand off the reviewed transcript and supplementary material paths for use with `typeset-lecture-transcription.md`.

Finish with the final transcript path, recording duration, backend and settings used,
coverage and verification checks, unresolved uncertainties with timestamps, cleanup confirmation, and any commit status.
For an unfinished run, report the retained working directory and blocker instead of claiming completion.

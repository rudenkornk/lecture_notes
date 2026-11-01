# Turn a lecture recording into compact notes

Create notes for the provided lecture in this repository, using its recording and supplementary materials.
The reader attended the lecture: the goal is compact reminders, not a textbook or a verbatim transcript.

Materials directory: `<path>`.
Course directory: `src/<course>/`.
Yandex API-key file: `<path>`.
Yandex folder ID: `<folder-id>`.

Follow repository instructions and inspect the existing course notes before starting.
Use the existing language, notation, typography, chapter structure, and illustration helpers.
You may independently choose summaries, layout, crops, compression, and transcription settings within these requirements.
Ask about missing required inputs, substantial source ambiguities, or changes to reusable tooling.
If several recordings could be the intended lecture, clarify which one to use.

## Inspect all materials

- Inventory the recording, slides, notebooks, and other supplements.
  Confirm the lecture topic, date, and next chapter number from the materials and existing notes.
- Inspect the recording's duration and audio streams.
  Review slides and notebook text, code, and saved outputs; use video frames for demonstrations and annotations.
- Let the recording determine topic coverage and emphasis.
  Use all supplied resources to clarify explanations, verify formulas, and choose illustrations.
  Reviewing a resource does not require including every topic it contains.
- Keep original materials unchanged.
  Store audio, raw recognition results, transcripts, previews, and processing scripts outside the repository,
  preferably in a `processed/` directory beside the materials.

## Extract and transcribe the full recording

Use the media devshell for audio extraction, transcription, and image processing.
`scripts/transcribe.py` uses only Python's standard library.

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
- Verify that the chunks cover the entire audio and that merging neither duplicates nor drops boundary phrases.
  Inspect uncertain joins against raw results and the recording.
  Account for genuine silence rather than treating every transcript gap as missing recognition.
- Read the complete transcript before drafting.
  Recognition can distort technical terms, negations, numbers, and spoken formulas;
  resolve these against slides, notebook code, and the relevant recording segment.

## Write concise recall notes

- Target preferably no more than three pages for the new lecture, using the existing font size and layout.
  Compress repetition and digressions before sacrificing readability or essential content.
  Ask if the main content cannot reasonably fit without a substantial omission.
- Preserve the main definitions, formulas, assumptions, algorithm steps, distinctions, and practical takeaways.
  Include a short example when it helps recall an important idea or common mistake.
- Condense classroom discussion, repeated explanations, long code demonstrations, and administrative remarks.
  Include code only when a small snippet is useful for remembering the method.
- Preserve qualifications made orally, even when slides state a simplified claim.
  Do not reproduce an obvious source typo as a mathematical fact or silently invent missing explanations.
  Ask about substantive uncertainties or conflicting claims.
- Organize the chapter around the lecture's main topics, preserving their logical progression.
  Check notation and terminology against earlier chapters.

## Crop source illustrations

- Use illustrations where they help recall the lecture.
  Illustrations usually are just crops from supplied materials,
  but you may freely generate or typeset new ones if needed.
- Prefer the clearest source: a slide, a saved notebook figure, or a video frame showing useful annotations.
  Extract notebook images from saved outputs when available.
- Crop tightly while retaining all meaningful axes, legends, labels, arrows, and annotations.
  Exclude unrelated interface elements, neighboring text, and empty margins.
  Do not leave cut-off titles or labels at crop boundaries.
- Save only final referenced assets in the course's existing assets directory.

## Compress without sacrificing readability

- Encode from the original crop rather than repeatedly recompressing an already compressed image.
- For photographic or video content, start with JPEG quality around 85;
  prefer 4:4:4 chroma sampling when colored text or fine lines would suffer from subsampling.
- For flat-color diagrams and plots, consider optimized PNG with an adaptive palette.
  Try a palette appropriate to the actual image, such as 64 or 256 colors;
  use fewer colors only if gradients, antialiasing, and distinctions remain legible.
  Do not force every image into eight colors.
- Retain enough resolution for the final printed size and avoid pointless upscaling.
  Flatten transparency onto the intended page background if the chosen format requires it.
- Compare compressed crops with their sources and inspect them in the rendered notes.
  Choose the smaller encoding only when its quality is acceptable.

## Integrate and verify

- Add the chapter to the course entry point and update affected metadata, such as the lecture count.
- Check content against the complete transcript and supplementary materials.
  Confirm that every major taught topic is represented at an appropriate level of detail.
- Compile the course and inspect every new output page at readable resolution.
  Check equations, column flow, captions, crop boundaries, small labels, and page breaks.
  Make sure self-generated typeset diagrams/images are properly displayed and fit.
  Make sure page breaks are nice and do not awkwardly split a figure, table, or paragraph.
  Verify the new chapter's page count without shrinking the shared typography.
- Run the repository's format, lint, and build checks.
  Preserve unrelated changes and inspect the final diff.

## Organize commits and report

- Reuse existing media and Python tooling.
  If approved tooling changes are needed, put mechanical preparation first, then tooling,
  then already formatted and checked scripts or instructions.
- Put the new notes, final compressed images, entry-point integration, and metadata updates
  into one final lecture commit.
  Fold corrections into the relevant commits from this task.
- Keep credentials, source recordings, extracted audio, transcripts, and generated PDFs out of Git.
  Do not push without an explicit request.

Finish with the course PDF path, the new lecture's page range and page count,
the locations of the extracted audio and transcript, checks performed, any unresolved uncertainties, and commit status.

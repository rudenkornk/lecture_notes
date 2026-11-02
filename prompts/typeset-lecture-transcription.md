# Typeset compact lecture notes from supplied materials

Create notes for the provided lecture in this repository, using the supplied materials.
Materials may include a transcript, slides, notebooks, PDFs, or other sources; a recording or transcript is not required.
The reader attended the lecture: the goal is compact reminders, not a textbook or a verbatim transcript.

Materials directory: `<path>`.
Course directory: `src/<course>/`.

Follow repository instructions and inspect the existing course notes before starting.
Use the existing language, notation, typography, chapter structure, and illustration helpers.
You may independently choose summaries, layout, crops, and compression within these requirements.
Ask about missing required inputs, substantial source ambiguities, or changes to reusable tooling.
If the intended lecture or the scope of the supplied materials is unclear, clarify it before drafting.
Do not extract audio or run speech recognition as part of this task; no API credentials are needed.

## Inspect all materials

- Inventory the supplied transcripts, slides, notebooks, PDFs, and other sources.
  Confirm the lecture topic, date, and next chapter number from the materials and existing notes.
- Read the complete transcript when supplied, preferring `transcript-reviewed.txt` over raw recognition output.
  Review slides, PDFs, and notebook text, code, and saved outputs.
  Use supplied recordings or video frames to clarify demonstrations and annotations when available.
- When a transcript is supplied, let the lecture determine topic coverage and emphasis.
  Otherwise, base coverage on the supplied materials and the agreed lecture scope.
  Use all supplied resources to clarify explanations, verify formulas, and choose illustrations.
  Reviewing a resource does not require including every topic it contains.
- Check any reported transcript uncertainties against the available sources.
  Ask about unresolved technical terms, negations, numbers, formulas, or conflicting claims that affect the notes.
- Keep original materials unchanged.
  Store previews and processing scripts outside the repository,
  preferably in a `processed/` directory beside the materials.

Use the media devshell for image processing.

## Write concise recall notes

- Target preferably no more than three pages for the new lecture, using the existing font size and layout.
  Compress repetition and digressions before sacrificing readability or essential content.
  Ask if the main content cannot reasonably fit without a substantial omission.
- Preserve the main definitions, formulas, assumptions, algorithm steps, distinctions, and practical takeaways.
  Include a short example when it helps recall an important idea or common mistake.
- Condense classroom discussion, repeated explanations, long code demonstrations, and administrative remarks.
  Include code only when a small snippet is useful for remembering the method.
- Preserve qualifications recorded in the supplied materials, including oral qualifications captured in a transcript,
  even when slides state a simplified claim.
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
- Check content against all supplied materials, including the complete transcript when available.
  Confirm that every major taught topic is represented at an appropriate level of detail.
- Compile the course and inspect every new output page at readable resolution.
  Check equations, column flow, captions, crop boundaries, small labels, and page breaks.
  Make sure self-generated typeset diagrams/images are properly displayed and fit.
  Make sure page breaks are nice and do not awkwardly split a figure, table, or paragraph.
  Verify the new chapter's page count without shrinking the shared typography.
- Run the repository's format, lint, and build checks.
  Preserve unrelated changes and inspect the final diff.

## Organize commits and report

- Reuse existing media tooling.
  If approved tooling changes are needed, put mechanical preparation first, then tooling,
  then already formatted and checked scripts or instructions.
- Put the new notes, final compressed images, entry-point integration, and metadata updates
  into one final lecture commit.
  Fold corrections into the relevant commits from this task.
- Keep credentials, source recordings, extracted audio, transcripts, and generated PDFs out of Git.
  Do not push without an explicit request.

Finish with the course PDF path, the new lecture's page range and page count,
the source materials used, checks performed, any unresolved uncertainties, and commit status.

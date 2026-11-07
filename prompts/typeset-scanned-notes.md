# Transcribe scanned lecture notes into Typst

Convert the provided handwritten or scanned lecture notes into polished Typst notes in this repository.

Source PDF: `<path>`.
Course directory: `src/<course>/`.

Follow repository instructions and existing conventions.
You may make routine layout and diagram choices independently.
Ask about substantive corrections or changes to topic order.

## Clarifications

Defer questions and clarifications about the notes until after the initial transcription,
unless a wrong assumption would require substantial rework.

While transcribing, make reasonable provisional choices and record ambiguities, suspected errors, and proposed corrections.
Do not silently treat uncertain readings or mathematical corrections as confirmed.

After transcription, record all ambiguities, suspected errors, and proposed corrections in a separate uncommitted file.

## Transcribe the complete source

- Preserve wording, formulas, tables, annotations, topic order, and unfinished fragments.
- Expand abbreviations and correct obvious typos.
- Do not invent explanations or silently repair mathematical claims.
- Track coverage so no source pages or content are omitted.

## Structure and typeset

- Use chapter files and a `main.typ` entry point.
- Import `style` from `../_shared/style.typ` and apply `#show: style` in the entry point.
  Import other shared helpers using relative paths.
- Reuse the shared A5, 9pt textbook typography, fonts, heading hierarchy, and colors.
  Do not recreate the style locally or change font sizes or margins to meet a page target.
- Let content flow naturally rather than matching source-page boundaries or keeping whole subsections on one page.
  Keep headings with following content and small diagrams and tables with their explanations.
- Prefer major topic headings at page starts when this improves the flow.
  Add selective page breaks, not a blanket break before every heading; let smaller subheadings flow unless awkward.
  Allow up to 10% more pages than the compact natural-flow layout, not as a target to fill.
  Avoid large empty areas and let longer sections span pages.

## Reproduce diagrams faithfully

- Use Typst/CeTZ for straightforward diagrams that can closely match the source.
- Check semantics, not merely appearance:
  arrows, positions, boundaries, labels, colors, and connections must retain their meaning.
- For complex diagrams or redraws that lose details, use tightly cropped source images.
- Preserve all diagram annotations while excluding neighboring text.
- Prefer a faithful source crop over an attractive but incomplete approximation.

## Compress cropped images

- Encode directly from the original source crops as JPEG quality 85.
- Disable chroma subsampling (4:4:4), retain original pixel resolution, and flatten transparency onto white.
- Do not repeatedly re-encode JPEGs.
- Visually compare compressed images against the source, especially fine strokes and colored annotations.
- Keep only the final referenced image assets in the repository.

## Verify thoroughly

- Compare the transcription and every illustration against the source.
- After approved compaction, verify mathematical correctness and the retained assumptions, qualifications,
  proof sketches, complexity claims, and failure cases.
- Render and inspect every output page at readable resolution.
- Fix clipping, overlapping labels, malformed formulas, incorrect diagram semantics, and awkward pagination.
  Confirm that the page count stays within the pagination budget without shrinking the shared typography.
- Run the repository's format, lint, and full build checks.
- Do not claim complete verification based only on thumbnails or selected pages.

## Preserve the original

- Copy the source PDF unchanged to `src/<course>/original.pdf`.
- Track that exact path with Git LFS through `.gitattributes`.
- Verify that Git stores an LFS pointer and that the working PDF matches the source byte-for-byte.
- Keep generated PDFs excluded from Git.

## Organize commits

- Put reusable styling, drawing/layout helpers, and LFS configuration before the transcription.
- Keep independently meaningful preparation in focused commits.
- Put all course transcription, final diagrams, compressed images, entry-point integration,
  and the original PDF into one final transcription commit.
- Fold subsequent corrections from this task into the relevant commits.
- Preserve unrelated work and history.
  Do not push without an explicit request.

Finish by reporting the generated PDF path, page count, file size, checks performed, unresolved ambiguities,
and commit status.

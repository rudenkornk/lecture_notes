# Typeset scanned homework without changing its content

Typeset the supplied handwritten homework in this repository.
This is strictly a transcription and typesetting task, not a request to solve or review the homework.

Source PDF: `<path>`.
Course homework directory: `src/<course>-hw/`.
Homework number: `<number>`.
Reference homework or template, if available: `<path>`.

Follow repository instructions and inspect the existing homework and applicable template before starting.

## Preserve the submitted work

- Preserve the wording, formulas, notation, problem numbering, order, annotations, and diagram content.
- Preserve informal remarks, unfinished arguments, and incomplete attempts.
- Do not fix logical or mathematical errors, evaluate correctness, or point out suspected errors.
- Do not provide hints, solutions, alternative approaches, missing steps, or additional answers.
- Do not rewrite arguments to make them clearer, stronger, or more complete.
- Do not add problem statements or explanations absent from the source.
- You may correct unambiguous spelling and punctuation typos and expand abbreviated words without changing meaning.
- Do not change mathematical assumptions, quantifiers, operators, indices, bounds, or complexity claims.
- Track coverage so no source pages or content are omitted.

## Clarify unreadable content

- Ask about unclear words, symbols, indices, formulas, or diagram labels in small, focused batches.
- Identify the source page, problem, and location of each uncertainty.
- Do not choose a transcription because it would make the mathematics correct.
- Keep clarification questions neutral; do not reveal hints or discuss the validity of the argument.
- Do not silently guess unresolved content.
- Treat the user's clarifications as authoritative.

## Choose the document format and reuse its template

- Follow the format already established for this assignment or course's homework.
- If no format is established, default to Typst.
- Algorithms homework requires LaTeX and the predefined `src/algorithms-hw/hometask.sty`.
  Follow existing algorithms homework as the reference.
- Reuse the applicable styling, helpers, naming, and entry-point conventions.
- Preserve the reference homework's fonts, margins, headers, footers, and numbering conventions.
- Do not convert an established homework workflow to another format.
- Do not modify shared styling or add dependencies without approval.
- Use an assignment-specific entry point in the selected format.
- Do not overwrite another assignment's source or assets.

## Match the layout

- Approximately preserve the source's arrangement of text, equations, diagrams, and annotations.
- Normally start each problem on a new page.
- Allow long problems to continue naturally across pages.
- Avoid awkward breaks within short arguments, equations, or diagram groups.
- Keep diagrams and their associated labels or explanations together.
- Do not shrink typography merely to match the scan's page count or force a problem onto one page.

## Reproduce diagrams faithfully

- Prefer the existing drawing tools for the selected format:
  Typst/CeTZ for Typst, or TikZ and available LaTeX packages for LaTeX.
- Recreate diagrams when a faithful reproduction is practical.
- Preserve meaningful connections, arrows, boundaries, labels, positions, and color distinctions.
- Do not correct or supplement a diagram's mathematical content.
- Check that redrawing does not accidentally merge vertices, omit edges, or change associations.
- If faithful recreation is impractical, insert a tightly cropped source image instead.
- Retain all diagram annotations and exclude unrelated neighboring text.

## Compress raster assets and the scanned appendix

- Work directly from the original source, not from an already reduced or compressed derivative.
- Target 150 dpi for the full-page appendix scans.
- Use indexed-color images with lossless DEFLATE compression in the appendix PDF.
- Choose the smallest palette that preserves readable handwriting, faint marks, and meaningful color distinctions.
- Do not force every scan into four colors.
- For cropped diagrams, choose an optimized encoding and sufficient resolution for their final printed size.
- Compress as much as possible while preserving readability; modest quality loss is acceptable.
- Compare compressed images against the originals, including small indices, punctuation, and fine strokes.
- Keep the supplied source PDF unchanged.
- Store only the final referenced assets in the repository; keep processing scripts and previews outside it.

## Append the complete scan

- Save the compressed scan under an assignment-specific name, such as `handwritten-<number>.pdf`.
- Include every complete source page, in its original order, at the end of the final homework PDF.
- Do not crop the full-page appendix scans or remove apparently empty source pages.
- Follow the reference homework's appendix inclusion method where available, using the selected document format.
- Exclude appendix pages from the main document's displayed total page count.
- Do not display misleading main-document page numbers on the appended scans.

## Verify and commit

- Compare the complete transcription and every diagram against the source.
- Render and inspect every typeset and appendix page at readable resolution.
- Check formulas, diagram connections, labels, compression quality, clipping, and page breaks.
- Verify the main page count and confirm that every scanned page appears in the appendix.
- Run the repository's formatting, lint, and build checks.
- Preserve unrelated files, changes, and history.
- Keep independently necessary preparation separate from the final homework commit.
- Put the transcription, final diagrams, raster assets, and compressed appendix into one focused homework commit.
- Fold subsequent corrections into the relevant task commits when authorized.
- Do not commit generated output PDFs or push without an explicit request.

Finish by reporting the generated PDF path, main and appendix page counts,
compressed scan and output sizes, checks performed, unresolved transcription ambiguities,
and commit status.

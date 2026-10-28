# Clean scanned notebook PDFs

Turn scanned notebook notes into an upright PDF without duplicated notebook pages or unnecessary image data.
Preserve the original scan quality; do not experiment with lossy compression unless explicitly requested.

## Input and output

Ask me for the input PDF path if I have not supplied it.
Leave the original unchanged.
Unless I specify another destination, save the result beside it as `<input-stem>_clean.pdf`.
Never overwrite an existing output without asking.
Keep previews and intermediate files in a temporary working directory, outside the repository.

## Inspect the scans

Inspect metadata and previews of every PDF page before deciding how to process them.
Use smaller previews or contact sheets if the whole PDF is too large to view directly.
Inspect detailed images wherever cropping, faint writing, or scan pairing is uncertain.

Determine the following from the actual document, not assumptions about odd and even pages:

- The rotation needed to make each scan upright.
- Whether each scan contains a single notebook page or an open spread.
- Which scans show the same physical notebook spread.
- Which notebook pages are complete in each scan, and which are clipped.
- The reading order, blank pages, and any apparently missing content.

A spread may have been scanned twice, with the notebook rotated between scans because it did not fit on the scanner.
Those scans are complementary, not redundant: each may preserve writing clipped in the other.
Do not simply delete alternate scans or choose one entire scan from each pair.
Locate the notebook fold for each scan rather than splitting every image at its midpoint.

Describe the detected layout and any gaps or ambiguities before processing.
Ask about genuinely uncertain ordering or content instead of silently guessing.
Do not claim that no notebook pages were skipped merely because the scanned sequence looks plausible.

## Crop and orient

Produce one upright PDF page per written notebook page, in reading order.
For complementary scans, take each notebook page from the scan that captures it completely.
Omit clearly blank notebook pages, but do not mistake faint writing for blank paper.
Do not remove handwritten margins, diagrams, or annotations as background.
If no scan contains a complete notebook page, explain the problem and ask before stitching or discarding content.

Physically crop the embedded images and rebuild the PDF with those smaller images.
Changing only PDF crop boxes, clipping paths, or page dimensions is not sufficient:
the hidden scan halves must not remain embedded in the output.

Preserve the source resolution and color.
For JPEG scans, prefer lossless block-aligned cropping and lossless entropy optimization without requantization.
Retain a tiny hidden border when JPEG block alignment requires it, rather than cutting visible content.
PDF rotation or placement transforms may orient the cropped images without re-encoding them.
Avoid lossless JPEG transforms that trim incomplete edge blocks containing visible content.
For other image encodings, use lossless physical cropping where possible.

Do not downsample, reduce colors, binarize, remove paper texture, or apply another lossy JPEG encoding by default.
If the available approach requires quality loss or would discard other PDF content, explain the tradeoff and ask first.
Do not silently flatten text, annotations, or other non-image content.

## Validate and report

Verify the following before delivering the output:

- Every output page renders successfully and is upright.
- Page count and reading order match the identified written notebook pages.
- Each notebook page appears once, with no new clipping or missing annotations.
- Embedded images are physically smaller, apart from any required block-alignment border.
- Resolution and color are preserved, with no additional lossy encoding.

Where practical, compare retained decoded image pixels against the source.
Allow for decoder boundary differences at crop edges; inspect rendered pages as well.
Check dense formulas, small handwriting, and colored annotations in detailed spot checks.
Do not claim exact whole-page equality unless it was actually verified.

Report the output path, page count, original and final file sizes, and any remaining limitations.
State the actual quality-preservation method and confirm that the original file was left unchanged.

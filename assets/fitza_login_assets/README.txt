FITZA — LOGIN SCREEN ASSET PACK
================================

PNG assets extracted from the user-provided Fitza login screen reference:
- login_hero_landscape.png — landscape/sunset/person hero crop
- fitza_leaf_logo_reference.png — leaf symbol crop from the reference
- fitza_wordmark_reference.png — Fitza wordmark and tagline crop
- login_bottom_foliage.png — bottom-left decorative foliage crop

Individual SVG icons:
- mail.svg
- lock.svg
- eye.svg
- eye-off.svg
- arrow-right.svg
- leaf-mark.svg

Implementation:
- SVGs use a 24x24 viewBox (leaf-mark.svg uses 64x64).
- Icons use currentColor where appropriate; tint them at runtime.
- Flutter rendering: use the flutter_svg package.
- App typography: Manrope.
- Visual identity: sage/forest green, warm white, natural sunset imagery.

Note:
The logo PNGs are raster crops from the supplied reference, not a vector master.
The SVG leaf mark is a clean simple recreation for UI use, not a certified final
trademark/vector source.

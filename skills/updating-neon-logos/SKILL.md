---
name: updating-neon-logos
description: Updates Neon logos across repositories to match official brand assets. This skill should be used when updating, replacing, or auditing Neon logo files in any codebase to ensure brand consistency with neon.com/brand guidelines.
---

# Updating Neon Logos

This skill updates Neon logos in repositories to match official brand assets from https://neon.com/brand.

## Quick Start

To update logos in the current repository:

1. Run discovery to find all logo files
2. Review recommendations for each logo
3. Confirm which logos to update
4. Skill downloads official assets and replaces

## Official Brand Assets

### Logo Variants

| Variant | Use Case | URL |
|---------|----------|-----|
| Full Logo (Dark BG, Color) | Dark mode headers, footers | `https://neon.com/brand/neon-logo-dark-color.svg` |
| Full Logo (Light BG, Color) | Light mode headers, footers | `https://neon.com/brand/neon-logo-light-color.svg` |
| Logomark (Dark BG, Color) | Favicons, small spaces, app icons | `https://neon.com/brand/neon-logomark-dark-color.svg` |
| Logomark (Light BG, Color) | Favicons, small spaces, app icons | `https://neon.com/brand/neon-logomark-light-color.svg` |
| Full Package | All variants and formats | `https://neon.com/brand/neon-brand-assets.zip` |

### Favicon Assets (from neon.com/favicon/)

For favicons, download directly from neon.com rather than converting from brand assets:

| Asset | URL | Size |
|-------|-----|------|
| SVG Favicon (primary) | `https://neon.com/favicon/favicon.svg` | Vector |
| ICO Favicon (fallback) | `https://neon.com/favicon/favicon.ico` | 100x100 |
| Apple Touch Icon | `https://neon.com/favicon/apple-touch-icon.png` | 180x180 |

**Note:** Always prefer downloading these production-ready assets over converting from brand SVGs.

### Brand Guidelines

- Default to full-color complete logo
- Use logomark only when space is limited or displaying multiple brand symbols
- Maintain safety area spacing (defined by symbol height)
- Never edit, distort, recolor, or reconfigure logos

## Workflow

### Phase 1: Discovery

Search the repository for logo files and references:

**File searches:**
- `**/*neon*.{svg,png,jpg,jpeg,ico,webp}`
- `**/*logo*.{svg,png,jpg,jpeg,ico,webp}`
- `**/favicon.{ico,png,svg}`
- `**/og-image.{png,jpg}`

**Code reference searches:**
- Import statements: `import.*neon.*svg|png`
- HTML img tags: `<img.*neon|logo`
- CSS backgrounds: `url.*neon|logo`
- Markdown images: `!\[.*\].*neon|logo`

Present findings as a table with:
- File path
- Current format
- File size
- Usage context (if determinable from code)

### Phase 2: Analysis

For each discovered logo, determine:

1. **Logo Type Needed**
   - Full logo: For headers, footers, about pages, documentation
   - Logomark: For favicons, app icons, social thumbnails, small UI elements

2. **Background Context**
   - Dark background: Dark mode pages, dark headers
   - Light background: Light mode pages, white backgrounds

3. **Color vs Monochrome**
   - Color: Default, most use cases
   - Monochrome: When color restrictions apply

4. **Format Required**
   - SVG: Scalable elements, web components
   - PNG: Fixed-size images, OG images, social sharing
   - ICO: Favicons (browser compatibility)

### Phase 3: Recommendation

Present a recommendation table:

| Current File | Context | Recommended Replacement | Reason |
|--------------|---------|------------------------|--------|
| icons/neon.svg | Header component | neon-logo-dark-color.svg | Full logo for header |
| public/favicon.ico | Browser favicon | neon-logomark-dark-color.svg → ICO | Logomark for favicon |
| README.md reference | Documentation | neon-logo-dark-color.svg | External URL for docs |

### Phase 4: Confirmation

For each recommendation, ask the user:

> **Update [file path]?**
> Current: [description]
> Recommended: [official asset name]
> Reason: [context-based reasoning]
>
> Options: Yes / No / Skip All

### Phase 5: Update

For approved changes:

1. **Download official asset** using curl or WebFetch:
   ```bash
   curl -o [target-path] "https://neon.com/brand/[asset-name]"
   ```

2. **For favicons**, prefer downloading from neon.com/favicon/:
   ```bash
   curl -o public/favicon.svg "https://neon.com/favicon/favicon.svg"
   curl -o public/favicon.ico "https://neon.com/favicon/favicon.ico"
   curl -o public/apple-touch-icon.png "https://neon.com/favicon/apple-touch-icon.png"
   ```
   Only convert from brand SVG if customization is needed.

3. **For other format conversions** (SVG to PNG):
   - Use ImageMagick: `magick -background none -density 300 input.svg -resize 1000x1000 output.png`

4. **Update code references** if URLs are hardcoded:
   - Replace old URLs with official brand URLs
   - Update import paths if file names change

5. **Report changes**:
   ```
   ✅ Updated: icons/neon.svg → neon-logo-dark-color.svg
   ✅ Updated: public/logo.png → neon-logo-dark-color.png
   ⏭️ Skipped: public/favicon.ico (user declined)
   ```

## Decision Tree

```
Is space limited (< 100px or multi-brand context)?
├── Yes → Use Logomark
│   └── What's the background?
│       ├── Dark → neon-logomark-dark-color.svg
│       └── Light → neon-logomark-light-color.svg
└── No → Use Full Logo
    └── What's the background?
        ├── Dark → neon-logo-dark-color.svg
        └── Light → neon-logo-light-color.svg

What format is needed?
├── Scalable web element → Keep as SVG
├── Fixed size image → Convert to PNG
└── Browser favicon → Download from neon.com/favicon/
    ├── Primary: favicon.svg (vector)
    ├── Fallback: favicon.ico (100x100)
    └── iOS: apple-touch-icon.png (180x180)
```

## Examples

**Example 1: Header Logo**
- Context: Next.js header component, supports dark mode
- Current: Custom SVG in `icons/neon.svg`
- Recommendation: Replace with `neon-logo-dark-color.svg` for dark mode, add `neon-logo-light-color.svg` for light mode toggle

**Example 2: README Badge**
- Context: Markdown README file
- Current: Reference to old logo URL
- Recommendation: Update to `https://neon.com/brand/neon-logo-dark-color.svg`

**Example 3: Favicon**
- Context: Browser favicon
- Current: Generic `favicon.ico`
- Recommendation: Download complete favicon set from neon.com/favicon/:
  - `favicon.svg` (primary, vector)
  - `favicon.ico` (fallback, 100x100)
  - `apple-touch-icon.png` (iOS, 180x180)

## Guidelines

- Always ask for confirmation before modifying files
- Preserve original files as backups if requested
- Report all changes with before/after comparison
- For unknown contexts, ask user to clarify intended background color
- When in doubt, recommend the full color logo on dark background (most common)

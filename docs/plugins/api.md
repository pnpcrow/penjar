---
layout: layouts/plugins.njk
title: 4. API
desc: Create, deploy, and use the Penjar plugin API with our comprehensive documentation. Get started today and expand Penjar's capabilities.
---

# Penjar plugins API

For the full API reference, see the <a target="_blank" href="https://doc.plugins.penjar.app/">Penjar Plugin API documentation</a>.

## API overview

The plugin API is exposed via the global `penjar` object, available to all plugins at runtime. It provides access to file and page context, shape manipulation, selection state, event handling, and UI controls.

### Core capabilities

| Category | Description | Key methods |
|---|---|---|
| **Context** | Access the current file, page, and selection state | `penjar.currentFile`, `penjar.currentPage`, `penjar.selection` |
| **UI** | Open and manage the plugin UI panel | `penjar.ui.open(name, url, options)` |
| **Events** | Subscribe to workspace and selection events | `penjar.on(event, callback)`, `penjar.off(event, callback)` |
| **Shapes** | Create, modify, and inspect shapes on the canvas | `Shape.applyToken(token, properties)`, geometry/fill accessors |
| **Design tokens** | Access the token catalog in the current library | `TokenCatalog` interface for browsing and resolving tokens |
| **Geometry utilities** | Perform calculations on points, bounds, and matrices | Built-in geometry helper functions |

### Shape types

The API provides type predicates for identifying specific shape types:

- `isBoard`, `isFrame`, `isGroup`, `isMask`
- `isRectangle`, `isEllipse`, `isPath`
- `isText`, `isBool`, `isSVGRaw`, `isImage`

### Event types

Plugins can subscribe to workspace events including:

- `selectionchange` — Fires when the user selection changes
- `pagechange` — Fires when the active page changes
- `filechange` — Fires when the active file changes

### Token integration

Shapes support design token application via the `applyToken(token, properties)` method. Supported token types include: Color, Dimension, FontFamilies, FontSizes, FontWeights, LetterSpacing, Number, Opacity, Rotation, Sizing, Spacing, BorderWidth, BorderRadius, and Shadow.

## Getting started

1. Review the [Getting Started](/plugins/getting-started/) guide to set up your first plugin.
2. Explore [Examples & Templates](/plugins/examples-templates/) for reference implementations.
3. Consult the <a target="_blank" href="https://doc.plugins.penjar.app/">full API reference</a> for detailed type definitions and method signatures.

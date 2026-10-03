# NINAXIS

A compact 3×3×3 logic puzzle about seeing numbers in three dimensions.

## Core rule

NINAXIS has 27 cells arranged as a 3×3×3 cube. Fill them with digits 1–9 so that every 3×3 cross-section perpendicular to X, Y, and Z contains 1–9 exactly once.

That gives nine Sudoku-like planes in total:

- X = 1, 2, 3
- Y = 1, 2, 3
- Z = 1, 2, 3

## Design goal

The game begins as a calm 2D logic puzzle. The player mainly works with three 3×3 X-layers.

The key reveal arrives at Stage 010:

> Stop looking at a face. Look at one digit through the whole cube.

This introduces **TRIAD MATCH**. Each digit appears exactly three times in the cube, and those three cells must use X=1/2/3, Y=1/2/3, and Z=1/2/3 exactly once each.

Later stages build toward:

1. Singles
2. Hidden Single
3. Locked Intersection / CROSS LOCK
4. Pair
5. TRIAD MATCH
6. TWIN WEAVE
7. TRIPLE WEAVE
8. QUAD WEAVE

## Prototype scope v0.1

Implement and playtest only three milestone stages first:

- **Stage 001** — basic face logic
- **Stage 007** — CROSS LOCK / plane intersection
- **Stage 010** — first TRIAD MATCH aha moment

If Stage 010 feels good, expand to the full 20-stage tutorial pack.

## UI principle

**One 3D object, viewed through one 2D slice at a time.**

The visual reboot replaces the old stacked-three-X-layer prototype.

Normal play:
- one large active 3×3 slice
- X / Y / Z axis selector
- slice navigation 1/3–3/3
- small transparent 3×3×3 Cube Preview
- digit keypad, candidate mode, undo
- selected-cell X/Y/Z coordinates

Selection Lens:
- the selected canonical cell glows in the cube
- its three orthogonal X/Y/Z planes become visible
- the UI explains spatial relationships through motion rather than text walls

TRIAD MATCH:
- Stage 010 promotes the cube into the main visual
- Digit Focus isolates one digit's global candidates
- a valid three-cell spatial pattern becomes the signature aha moment

See `docs/VISUAL_IMPLEMENTATION_TASK_v0.1.md` for the current visual specification.

## Tech

- Godot 4.7
- Windows 11 development target
- Portrait mobile reference: 360×800 / 720×1280
- 2D UI: Control nodes
- Cube Lens: isolated Node3D/SubViewport layer

## Data

Tutorial data lives in `data/stages_001_020.json`.

## Status

Experimental prototype. Rules and technique names may change after human playtesting.
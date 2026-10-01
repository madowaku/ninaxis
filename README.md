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

**2D first, 3D only when it adds understanding.**

Normal play:
- three 3×3 X-layer boards
- digit keypad 1–9
- candidate mode
- undo
- selected-cell X/Y/Z coordinates

Cube Lens:
- small 3D helper, not the main board
- highlights the selected cell and its three planes
- Digit Focus can isolate one digit's candidates across the cube
- Stage 010 temporarily promotes the cube into the foreground for TRIAD MATCH

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

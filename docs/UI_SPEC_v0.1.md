# NINAXIS UI Prototype v0.1

## Experience target

The UI must preserve one central idea:

> The player solves in 2D until a 3D relationship becomes meaningful.

Do not make free cube rotation the default interaction.

## Normal play screen

Portrait-first layout.

### Header
- Stage number
- technique/chapter label
- Undo
- Hint
- Settings

### Main board
Display three X-layers as three 3×3 grids.

On narrow screens, stack vertically or use a compact 3-column layout only if every cell remains comfortably tappable.

Selected cell shows:
- value/candidates
- coordinates Xn / Yn / Zn
- peers on its X/Y/Z planes

### Input
- digits 1–9
- candidate mode
- erase
- Cube Lens

## Cube Lens

Cube Lens is a reasoning tool, not a separate game mode.

When opened:
- show a translucent 3×3×3 cube
- highlight selected cell
- highlight its three cross-section planes
- preserve the 2D board state
- one tap closes the lens

## Digit Focus

Long-press or dedicated focus action on a digit:
- dim unrelated digits
- show all candidates for the focused digit
- in Cube Lens, show candidate cells spatially

This becomes essential after Stage 010.

## Tutorial progression

### 001–003 FACE
Teach basic completion without emphasizing 3D.

### 004–006 HIDDEN
Teach hidden placement.

### 007–008 CROSS
Introduce intersection of two planes.
Working player-facing term: **CROSS LOCK**.

### 009 PAIR
One compact pair lesson.

### 010 TRIAD AHA

This stage is the identity reveal.

Trigger after face-based reasoning stalls.

Sequence:

1. Dim the board.
2. Show: **LOOK AT 3**
3. Leave only confirmed/candidate 3s visible.
4. Promote Cube Lens into foreground.
5. Explain: **3 appears three times in the cube.**
6. Explain: **Those three cells use X, Y and Z exactly once each.**
7. Player selects the two cells that complete the triad.
8. Invalid same-axis choices give a small collision feedback.
9. Correct triad connects with three subtle segments.
10. Impossible 3-candidates fade.
11. A {3,9} cell resolves to 9.
12. Return control immediately and let the solve cascade continue.

Avoid a long modal tutorial.

### 011–014 TRIAD
No full explanation. Let the player reuse Digit Focus and Cube Lens.

### 015–020 WEAVE
Compare valid triads from multiple digits.

Visual distinction should not rely on color alone. Combine:
- solid line
- dashed line
- double line
- shape markers

## Milestone prototype

First implementation should include only:
- Stage 001
- Stage 007
- Stage 010

Success criterion:
A first-time player can explain TRIAD MATCH in their own words after Stage 010.

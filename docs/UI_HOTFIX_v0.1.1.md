# UI Hotfix v0.1.1

## Goal

Make the 3-layer structure readable at a glance before adding CROSS LOCK or Cube Lens.

## Changes

### Cell states

- Empty: white cell, light border
- Given: soft gray fill, dark number
- Player entry: pale blue fill, blue number
- Candidate notes: white fill, blue notes
- Selected: stronger cyan fill and border
- Same X/Y/Z planes: subtle cyan highlight
- Conflict: pale red with red border

### Layer hierarchy

Each X layer is now its own compact card:

- LAYER X = 1
- LAYER X = 2
- LAYER X = 3

The cards should read as three separate 3×3 faces rather than one 9×3 matrix.

### Header

Add the small subtitle:

3 × 3 × 3 LOGIC

### Controls

- Candidate mode visibly changes when ON.
- Check remains available but visually secondary.
- Full valid completion still triggers CLEAR automatically.
- Digit keypad uses a light neutral key style instead of the default dark Godot buttons.

## Mobile target

Primary reference: 360×800.

Keep every number key comfortably tappable while preserving all three layers on one screen.

## Acceptance check

On a fresh Stage 001 screenshot, a tester should be able to identify without explanation:

1. which cells are clues,
2. which cells are empty,
3. which cell is selected,
4. which cells share a plane with it,
5. that the board consists of three separate X layers.

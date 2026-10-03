# NINAXIS Visual Implementation Task v0.1

## Status

**Visual Reboot specification. This document supersedes the old stacked-three-X-layer UI direction in `docs/UI_SPEC_v0.1.md`.**

Do not delete the existing puzzle engine, stage data, validation logic, localization, or input rules. Replace the presentation layer around them.

---

## 1. Goal

Make NINAXIS communicate its identity before the player reads a paragraph of rules.

The screen should immediately suggest:

> This is one 3×3×3 object viewed through slices.  
> One cell belongs to three orthogonal planes at the same time.

The visual target is a **bright transparent mathematical toy**:
- glass / acrylic / crystal-like cells,
- white to very-light-gray space,
- cyan / blue interaction light,
- restrained warm gold for givens and important discoveries,
- calm, premium, precise rather than dark terminal / hacker styling.

The game must **not** read as three small Sudoku boards stacked vertically.

---

## 2. Three target screen states

The implementation is judged primarily by these three states.

### A. Normal Play

Normal play uses:

- one large active 3×3 slice,
- X / Y / Z axis selector,
- slice index 1 / 3,
- a small 3×3×3 cube preview showing where the active slice exists,
- number keypad 1–9,
- candidate mode,
- undo,
- hint/help access.

Do **not** show all three X-layers as full-size boards at the same time.

Suggested hierarchy:

```text
NINAXIS                     ?  ⚙
Stage 001 · FACE

        [small 3×3×3 cube]
        active slice glows

          X   Y   Z
             ↓
       X = 1   1 / 3
        ┌──┬──┬──┐
        │3 │  │  │
        ├──┼──┼──┤
        │5 │8 │  │
        ├──┼──┼──┤
        │2 │7 │4 │
        └──┴──┴──┘

       1 2 3 4 5
       6 7 8 9 ⌫
     候補   戻す   ヒント
```

The adjacent slices may be hinted at with small perspective ghosts or arrows, but they must not compete with the active board.

### B. Cell Selected

When a cell is tapped, NINAXIS should visually explain its core rule.

Example selected coordinate:

`X2 · Y1 · Z3`

Show that this one cell belongs to:
- X = 2 plane,
- Y = 1 plane,
- Z = 3 plane.

The small cube should expand or promote into a **Selection Lens**:
- selected cube cell glows,
- three orthogonal translucent planes emerge through it,
- X, Y and Z planes are labeled,
- the same selected value is visually shared across the three views.

This is not a modal rule page. It is a short, direct visual reaction to selection.

The player should understand the relationship from motion and geometry.

### C. TRIAD MATCH

Stage 010 is the identity reveal.

At the TRIAD tutorial trigger:
1. soften unrelated numbers and UI,
2. focus digit 3,
3. promote the transparent 3×3×3 cube to the main visual,
4. display confirmed and candidate positions for 3,
5. ask the player to choose the three valid positions,
6. invalid positions may fade or receive a restrained ×,
7. valid three cells glow gold and connect,
8. after success, eliminate impossible candidates,
9. resolve the intended {3,9} consequence,
10. return to normal play quickly.

Player-facing copy may use:

- **TRIAD MATCH**
- **数字3の軌道を見る**
- **3を3個選ぶ**

Do not turn this into a long explanation dialog.

The reward is the spatial pattern becoming visible.

---

## 3. Visual language

### Background
Near-white / cool very-light gray.

Avoid:
- black / navy full-screen backgrounds,
- dense terminal panels,
- glowing cyberpunk chrome,
- excessive bloom.

### Primary interaction color
Cyan / clear blue.

Use for:
- selected cell,
- active axis,
- active slice,
- player-entered digits,
- selection-plane edges,
- interactive focus.

### Secondary discovery color
Warm gold.

Use sparingly for:
- givens,
- TRIAD confirmed cells,
- important tutorial emphasis.

Gold must not become a general button color.

### Cell states

Normal board:
- empty: transparent-white / frosted, very low-contrast center marker optional,
- given: warm gold numeral,
- player entry: cyan/blue numeral,
- candidate notes: small cool-neutral or cyan text,
- selected: cyan rim/light,
- conflict: restrained coral/red border,
- solved/confirmed tutorial event: short pulse only.

### Glass treatment

Prefer native Godot implementation:
- StyleBoxFlat gradients are optional,
- semi-transparent panels,
- thin borders,
- subtle inner/highlight lines,
- small shadows where cheap,
- 3D transparent materials for the Cube Lens.

Do not rely on generated raster images for the functional UI.

The goal is the **feeling** of the concept art, not pixel-for-pixel reproduction.

---

## 4. Interaction model

### Axis selector
Three segmented controls:

`X | Y | Z`

Changing axis changes the active 3×3 plane family.

### Slice selector
For the active axis, navigate:

`1 / 3`, `2 / 3`, `3 / 3`

Support:
- left/right buttons,
- horizontal swipe if straightforward,
- keyboard arrows for desktop testing.

### Cell coordinates

Every internal cell has one canonical coordinate:

`(x, y, z)` where each value is 1–3.

The displayed 3×3 board is only a view into the same 27-cell state.

Changing X/Y/Z view must never create duplicated state.

### Input
Keep existing:
- 1–9,
- erase,
- candidate mode,
- undo,
- conflict checks,
- automatic clear detection.

### No mandatory free rotation

Do not make free 3D cube rotation required for solving.

The Cube is a semantic visualizer.

Optional drag rotation may be added later only if it improves understanding.

---

## 5. Cube Lens implementation

Recommended Godot 4.7 structure:

```text
GameScreen (Control)
├─ Header
├─ StageInfo
├─ CubePreview (SubViewportContainer)
│  └─ SubViewport
│     └─ CubeLensRoot (Node3D)
│        ├─ Camera3D
│        ├─ Light3D
│        ├─ CellInstances / MeshInstance3D
│        ├─ PlaneX
│        ├─ PlaneY
│        └─ PlaneZ
├─ AxisSelector
├─ SliceBoard (Control)
├─ Keypad
└─ BottomActions
```

Suggested scripts:
- `src/game_screen.gd` — UI orchestration,
- `src/slice_board.gd` — maps one plane to 9 canonical cells,
- `src/cube_lens.gd` — 3D cells, plane highlighting, triad visualization,
- keep stage/data logic separate from visuals.

A MultiMesh is optional. With only 27 cells, clarity is more important than premature optimization.

### 3D cell representation

A cell can be a BoxMesh with:
- transparent material,
- thin visible edges or slightly separated blocks,
- no physically expensive refraction requirement.

Fake the premium glass look rather than chasing expensive realistic glass.

Target Android-friendly rendering.

---

## 6. Selection Lens behavior

On cell selection:

1. board cell gets a cyan rim,
2. cube preview centers visual attention on the same canonical cell,
3. its X/Y/Z planes become visible,
4. coordinate readout appears,
5. optionally show two small perspective side-plane previews beside the main board.

Animation target:
- 150–300 ms,
- ease out,
- no long camera travel.

The interaction should feel like the cube saying:

> This cell is here, here, and here at once.

---

## 7. TRIAD MATCH behavior

Use the existing Stage 010 tutorial metadata in `data/stages_001_020.json` as the source of truth.

Do not hard-code the entire puzzle state into visual scripts.

### Digit Focus

When focusing digit 3:
- keep confirmed 3s strong,
- display candidate cells spatially,
- dim unrelated values,
- allow candidate cells to be selected.

### Triad validity

For three cells belonging to the same digit, a valid triad must use:
- X = 1,2,3 once each,
- Y = 1,2,3 once each,
- Z = 1,2,3 once each.

Visually explain invalid selections through the repeated axis, not through a generic error popup.

Example:
- two selected cells both have X=2,
- their X plane briefly pulses coral,
- small feedback indicates duplicate X,
- player can immediately try again.

### Triad success

On valid triad:
- three cells move to warm gold,
- draw connecting spatial segments,
- impossible digit candidates fade,
- hold the completed pattern for ~500–800 ms,
- continue the puzzle.

Avoid fireworks. The logical pattern itself is the spectacle.

---

## 8. Stage scope

For this visual implementation pass, fully support only the milestone experience:

### Stage 001
Validate:
- normal slice navigation,
- cell input,
- candidate notes,
- board readability.

### Stage 007
Add:
- Digit Focus foundation,
- CROSS LOCK plane/intersection visual language.

### Stage 010
Add:
- Selection Lens,
- TRIAD MATCH tutorial,
- spatial candidate selection,
- valid triad feedback.

Do not spend this pass polishing Stages 011–020.

The data must remain compatible with all 20.

---

## 9. Japanese / English

Preserve the current JA / EN language switch and saved language preference.

Update localization strings for the new concepts, including at minimum:

- axis / slice labels,
- coordinate explanation,
- TRIAD MATCH,
- LOOK AT / focus instruction,
- valid triad,
- invalid repeated axis,
- Cube / plane terminology.

Avoid embedding player-facing Japanese directly into new visual scripts when a localization key is appropriate.

---

## 10. Responsive requirements

Primary targets:
- 360×800,
- 720×1280.

### 360×800 acceptance

Normal play must show without page scrolling:
- header,
- cube preview,
- active 3×3 slice,
- 1–9 keypad,
- candidate / undo controls.

The full-screen TRIAD MATCH moment may temporarily devote more height to the cube, but its required controls must remain reachable.

No tiny tap targets:
- aim for ~44 logical px where possible,
- do not shrink the 3×3 board into illegibility just to fit decorative content.

On narrow screens, decoration is the first thing to reduce.

---

## 11. Preserve

Do not regress:
- stage JSON loading,
- uniqueness-validated 20 stage pack,
- canonical 27-cell state,
- given protection,
- candidate notes,
- undo,
- duplicate detection,
- completion detection,
- JA / EN,
- saved language,
- first-run help access,
- Godot 4.7 clean launch.

Run the stage validator after changes:

```bash
python tools/validate_stage_pack.py
```

---

## 12. Remove / retire from the old prototype

Retire these as the main visual concept:
- three full X-layer boards stacked vertically,
- dark terminal theme,
- permanent wall of candidate-dot placeholders,
- long vertical scrolling as normal play,
- `X=1 / X=2 / X=3` being understandable only through text labels.

Old code can be kept temporarily during refactor, but the final v0.1 visual path must not depend on the stacked-three-board presentation.

---

## 13. Implementation order

### TASK-001 — Visual foundation
- bright background,
- new cyan / gold palette,
- glass-like panel/cell theme,
- compact NINAXIS header,
- remove dark terminal feel.

### TASK-002 — Canonical SliceBoard
- one active 3×3 board,
- X/Y/Z axis switch,
- 1/3–3/3 slice navigation,
- map all views to canonical 27 cells,
- preserve input/notes/undo.

### TASK-003 — CubePreview
- 3×3×3 transparent visual,
- active slice highlight,
- axis labels,
- synchronized with SliceBoard.

### TASK-004 — Selection Lens
- selected canonical cell,
- X/Y/Z planes through that cell,
- coordinate readout,
- 150–300 ms transition.

### TASK-005 — Stage 007 visual language
- Digit Focus,
- plane intersection / CROSS LOCK highlighting,
- candidate fade feedback.

### TASK-006 — Stage 010 TRIAD MATCH
- tutorial trigger from stage data,
- spatial digit-3 candidates,
- three-cell selection,
- axis-duplication feedback,
- valid triad connection,
- elimination payoff.

### TASK-007 — Localization / help rewrite
- update JA / EN copy,
- explain slicing through visuals,
- keep help concise.

### TASK-008 — QA
- Godot 4.7 no errors/warnings,
- stage validator passes,
- 360×800,
- 720×1280,
- mouse,
- touch,
- keyboard debug input,
- language persistence.

---

## 14. Acceptance gates

### Gate A — Screenshot test
A screenshot of normal play should **not** be reasonably described as:
> three tiny Sudoku boards stacked vertically.

It should read as:
> one 3D puzzle being viewed through a 2D slice.

### Gate B — Selection comprehension
Without opening the help page, a tester can answer:
> What do X, Y and Z have to do with the selected cell?

Expected understanding:
> The cell belongs to one plane on each of the three axes.

### Gate C — Stage 010 AHA
After the guided TRIAD MATCH once, the tester can explain:
> Why do the three 3s have to occupy those positions?

Expected understanding:
> The three occurrences use all three X, all three Y, and all three Z coordinates exactly once.

### Gate D — Functional regression
Stage 001 remains fully playable from load to CLEAR, and existing core puzzle validation remains intact.

---

## 15. Deliverables

When done, report:

1. files changed,
2. screenshots at 360×800 for:
   - normal play,
   - selected-cell state,
   - TRIAD MATCH state,
3. Godot 4.7 launch result,
4. validator result,
5. manual test notes for Stages 001 / 007 / 010,
6. any visual compromises made for mobile performance,
7. commit SHA.

Do not spend time on store assets, title animation, achievements, monetization, or all-20-stage polish in this task.

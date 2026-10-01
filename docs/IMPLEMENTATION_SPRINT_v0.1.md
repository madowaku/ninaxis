# NINAXIS Implementation Sprint v0.1

## Goal

Prove the core game feel before building the full product.

The milestone path is:

1. Stage 001: basic 2D play feels good.
2. Stage 007: CROSS LOCK is understandable.
3. Stage 010: TRIAD MATCH creates the first major aha moment.

## Sprint 1: Core board

Status: implemented in the first prototype pass.

- load stage JSON
- render three X layers
- select cells
- enter digits 1-9
- candidate notes
- erase
- undo
- highlight cells sharing X, Y, or Z plane
- duplicate/conflict feedback
- complete-board validation
- keyboard shortcuts for desktop testing
- debug stage switcher for 001 / 007 / 010

Acceptance: Stage 001 can be completed from start to CLEAR without editing source data.

## Sprint 2: CROSS LOCK

Target: Stage 007.

- Digit Focus mode
- show all candidate positions for one digit
- highlight an intersection line shared by two planes
- animate impossible candidates fading
- one compact tutorial beat, then return control

Acceptance: a first-time tester can explain why the locked candidate was removed.

## Sprint 3: TRIAD MATCH

Target: Stage 010.

- Cube Lens using Node3D or SubViewport
- promote Cube Lens only when 2D logic stalls
- LOOK AT 3 tutorial beat
- let the player select the three-cell global digit pattern
- detect same-axis invalid triads
- fade impossible candidates
- resolve the {3,9} cell to 9 and let the cascade continue

Acceptance: after Stage 010, the tester can explain TRIAD MATCH without reading the rule text again.

## Sprint 4: Tutorial pack

After 001 / 007 / 010 are proven:

- enable Stages 001-020
- add chapter progression
- add restart / stage clear flow
- save progress
- tune copy and animation timing
- phone playtest at 360x800 and 720x1280

## Data safety

Run:

python tools/validate_stage_pack.py

The validator checks:
- 20 stages exist
- every solution has valid X/Y/Z planes
- all givens match the stored solution
- every puzzle has exactly one solution

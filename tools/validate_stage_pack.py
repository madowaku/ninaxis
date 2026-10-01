#!/usr/bin/env python3
"""Validate NINAXIS stage data, including uniqueness via backtracking."""

from __future__ import annotations

import json
import sys
from pathlib import Path

DIGITS = set(range(1, 10))


def coords(index: int) -> tuple[int, int, int]:
    return index // 9, (index % 9) // 3, index % 3


PLANES = [
    [i for i in range(27) if coords(i)[axis] == k]
    for axis in range(3)
    for k in range(3)
]
CELL_PLANES = [[] for _ in range(27)]
for plane_index, plane in enumerate(PLANES):
    for cell in plane:
        CELL_PLANES[cell].append(plane_index)


def valid_solution(solution: list[int]) -> bool:
    return len(solution) == 27 and all({solution[i] for i in plane} == DIGITS for plane in PLANES)


def count_solutions(puzzle: list[int], limit: int = 2) -> int:
    values = list(puzzle)
    used = [set() for _ in PLANES]

    for cell, value in enumerate(values):
        if value == 0:
            continue
        if value not in DIGITS:
            return 0
        for plane in CELL_PLANES[cell]:
            if value in used[plane]:
                return 0
            used[plane].add(value)

    count = 0

    def candidates(cell: int) -> set[int]:
        banned: set[int] = set()
        for plane in CELL_PLANES[cell]:
            banned |= used[plane]
        return DIGITS - banned

    def search() -> None:
        nonlocal count
        if count >= limit:
            return

        best_cell = -1
        best_options: set[int] | None = None
        for cell, value in enumerate(values):
            if value != 0:
                continue
            options = candidates(cell)
            if not options:
                return
            if best_options is None or len(options) < len(best_options):
                best_cell = cell
                best_options = options
                if len(options) == 1:
                    break

        if best_cell == -1:
            count += 1
            return

        assert best_options is not None
        for digit in sorted(best_options):
            values[best_cell] = digit
            for plane in CELL_PLANES[best_cell]:
                used[plane].add(digit)
            search()
            for plane in CELL_PLANES[best_cell]:
                used[plane].remove(digit)
            values[best_cell] = 0
            if count >= limit:
                return

    search()
    return count


def main() -> int:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "data/stages_001_020.json")
    pack = json.loads(path.read_text(encoding="utf-8"))
    stages = pack.get("stages", [])
    errors: list[str] = []

    if len(stages) != 20:
        errors.append(f"expected 20 stages, got {len(stages)}")

    for stage in stages:
        sid = stage.get("id", "???")
        puzzle = stage.get("puzzle", [])
        solution = stage.get("solution", [])
        if len(puzzle) != 27:
            errors.append(f"{sid}: puzzle has {len(puzzle)} cells")
            continue
        if not valid_solution(solution):
            errors.append(f"{sid}: invalid solution planes")
            continue
        for cell, value in enumerate(puzzle):
            if value and value != solution[cell]:
                errors.append(f"{sid}: given mismatch at cell {cell}")
        solutions = count_solutions(puzzle)
        if solutions != 1:
            errors.append(f"{sid}: expected unique solution, got {solutions}")

    if errors:
        print("NINAXIS stage validation FAILED")
        for error in errors:
            print(f"- {error}")
        return 1

    print(f"NINAXIS stage validation OK: {len(stages)} stages, all unique and rule-valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

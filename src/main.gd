extends Control

const StageRepository = preload("res://src/stage_repository.gd")
const MILESTONE_IDS := ["001", "007", "010"]
const DIGITS := [1, 2, 3, 4, 5, 6, 7, 8, 9]

var repo := StageRepository.new()
var stage: Dictionary = {}
var values: Array = []
var givens: Array = []
var notes: Array = []
var history: Array = []
var selected_index := -1
var candidate_mode := false

var cell_buttons: Array[Button] = []
var stage_picker: OptionButton
var stage_title_label: Label
var coord_label: Label
var status_label: Label
var candidate_button: Button

func _ready() -> void:
    if not repo.load_pack():
        _show_fatal("Could not load tutorial stage data.")
        return
    _build_ui()
    _load_stage("001")

func _build_ui() -> void:
    var background := ColorRect.new()
    background.color = Color("f5f7fb")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(background)
    move_child(background, 0)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 14)
    margin.add_theme_constant_override("margin_right", 14)
    margin.add_theme_constant_override("margin_top", 14)
    margin.add_theme_constant_override("margin_bottom", 14)
    add_child(margin)

    var root_v := VBoxContainer.new()
    root_v.add_theme_constant_override("separation", 8)
    margin.add_child(root_v)

    var header := HBoxContainer.new()
    header.add_theme_constant_override("separation", 8)
    root_v.add_child(header)

    var brand := Label.new()
    brand.text = "NINAXIS"
    brand.add_theme_font_size_override("font_size", 24)
    brand.add_theme_color_override("font_color", Color("172033"))
    header.add_child(brand)

    var spacer := Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    header.add_child(spacer)

    stage_picker = OptionButton.new()
    stage_picker.custom_minimum_size = Vector2(92, 40)
    for id in MILESTONE_IDS:
        stage_picker.add_item("Stage %s" % id)
        stage_picker.set_item_metadata(stage_picker.item_count - 1, id)
    stage_picker.item_selected.connect(_on_stage_selected)
    header.add_child(stage_picker)

    var rule := Label.new()
    rule.text = "9枚の3×3断面すべてに 1〜9 を1回ずつ"
    rule.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    rule.add_theme_font_size_override("font_size", 13)
    rule.add_theme_color_override("font_color", Color("667085"))
    root_v.add_child(rule)

    stage_title_label = Label.new()
    stage_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stage_title_label.add_theme_font_size_override("font_size", 17)
    stage_title_label.add_theme_color_override("font_color", Color("344054"))
    root_v.add_child(stage_title_label)

    var board := VBoxContainer.new()
    board.size_flags_vertical = Control.SIZE_EXPAND_FILL
    board.alignment = BoxContainer.ALIGNMENT_CENTER
    board.add_theme_constant_override("separation", 5)
    root_v.add_child(board)

    for x in range(3):
        var layer_row := HBoxContainer.new()
        layer_row.alignment = BoxContainer.ALIGNMENT_CENTER
        layer_row.add_theme_constant_override("separation", 9)
        board.add_child(layer_row)

        var layer_label := Label.new()
        layer_label.text = "X=%d" % (x + 1)
        layer_label.custom_minimum_size = Vector2(38, 0)
        layer_label.add_theme_font_size_override("font_size", 14)
        layer_label.add_theme_color_override("font_color", Color("475467"))
        layer_row.add_child(layer_label)

        var grid := GridContainer.new()
        grid.columns = 3
        grid.add_theme_constant_override("h_separation", 4)
        grid.add_theme_constant_override("v_separation", 4)
        layer_row.add_child(grid)

        for local_i in range(9):
            var index := x * 9 + local_i
            var cell := Button.new()
            cell.custom_minimum_size = Vector2(52, 43)
            cell.focus_mode = Control.FOCUS_NONE
            cell.pressed.connect(_on_cell_pressed.bind(index))
            grid.add_child(cell)
            cell_buttons.append(cell)

    coord_label = Label.new()
    coord_label.text = "セルを選択"
    coord_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    coord_label.add_theme_font_size_override("font_size", 13)
    coord_label.add_theme_color_override("font_color", Color("667085"))
    root_v.add_child(coord_label)

    var digits_grid := GridContainer.new()
    digits_grid.columns = 5
    digits_grid.add_theme_constant_override("h_separation", 5)
    digits_grid.add_theme_constant_override("v_separation", 5)
    root_v.add_child(digits_grid)

    for digit in DIGITS:
        var digit_button := Button.new()
        digit_button.text = str(digit)
        digit_button.custom_minimum_size = Vector2(58, 42)
        digit_button.add_theme_font_size_override("font_size", 18)
        digit_button.pressed.connect(_input_digit.bind(digit))
        digits_grid.add_child(digit_button)

    var erase := Button.new()
    erase.text = "⌫"
    erase.custom_minimum_size = Vector2(58, 42)
    erase.tooltip_text = "消す"
    erase.pressed.connect(_erase_selected)
    digits_grid.add_child(erase)

    var controls := HBoxContainer.new()
    controls.alignment = BoxContainer.ALIGNMENT_CENTER
    controls.add_theme_constant_override("separation", 5)
    root_v.add_child(controls)

    candidate_button = Button.new()
    candidate_button.text = "候補 OFF"
    candidate_button.toggle_mode = true
    candidate_button.custom_minimum_size = Vector2(92, 40)
    candidate_button.toggled.connect(_on_candidate_toggled)
    controls.add_child(candidate_button)

    var undo := Button.new()
    undo.text = "Undo"
    undo.custom_minimum_size = Vector2(68, 40)
    undo.pressed.connect(_undo)
    controls.add_child(undo)

    var check := Button.new()
    check.text = "Check"
    check.custom_minimum_size = Vector2(78, 40)
    check.pressed.connect(_check_board)
    controls.add_child(check)

    status_label = Label.new()
    status_label.custom_minimum_size = Vector2(0, 38)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status_label.add_theme_font_size_override("font_size", 13)
    status_label.add_theme_color_override("font_color", Color("344054"))
    root_v.add_child(status_label)

func _load_stage(id: String) -> void:
    var found := repo.get_stage(id)
    if found.is_empty():
        status_label.text = "Stage %s not found." % id
        return
    stage = found
    values = stage["puzzle"].duplicate()
    givens.clear()
    notes.clear()
    for value in values:
        givens.append(int(value) != 0)
        notes.append([])
    history.clear()
    selected_index = -1
    candidate_mode = false
    candidate_button.button_pressed = false
    candidate_button.text = "候補 OFF"
    stage_title_label.text = "Stage %s · %s" % [stage["id"], stage["title_ja"]]
    status_label.text = "3つのXレイヤーから始めよう。"
    for i in range(stage_picker.item_count):
        if String(stage_picker.get_item_metadata(i)) == id:
            stage_picker.select(i)
            break
    _refresh_cells()

func _on_stage_selected(item_index: int) -> void:
    _load_stage(String(stage_picker.get_item_metadata(item_index)))

func _on_cell_pressed(index: int) -> void:
    selected_index = index
    var c := _coords(index)
    coord_label.text = "X%d · Y%d · Z%d" % [c.x + 1, c.y + 1, c.z + 1]
    _refresh_cells()

func _input_digit(digit: int) -> void:
    if not _editable_selection():
        return
    _push_history()
    if candidate_mode:
        if values[selected_index] != 0:
            values[selected_index] = 0
        var cell_notes: Array = notes[selected_index]
        if digit in cell_notes:
            cell_notes.erase(digit)
        else:
            cell_notes.append(digit)
            cell_notes.sort()
    else:
        values[selected_index] = digit
        notes[selected_index].clear()
    status_label.text = ""
    _refresh_cells()
    _announce_if_complete()

func _erase_selected() -> void:
    if not _editable_selection():
        return
    if values[selected_index] == 0 and notes[selected_index].is_empty():
        return
    _push_history()
    values[selected_index] = 0
    notes[selected_index].clear()
    status_label.text = ""
    _refresh_cells()

func _on_candidate_toggled(enabled: bool) -> void:
    candidate_mode = enabled
    candidate_button.text = "候補 ON" if enabled else "候補 OFF"

func _undo() -> void:
    if history.is_empty():
        status_label.text = "戻せる手はまだない。"
        return
    var snapshot: Dictionary = history.pop_back()
    values = snapshot["values"]
    notes = snapshot["notes"]
    status_label.text = "1手戻した。"
    _refresh_cells()

func _push_history() -> void:
    history.append({
        "values": values.duplicate(),
        "notes": _copy_notes()
    })
    if history.size() > 100:
        history.pop_front()

func _copy_notes() -> Array:
    var copied: Array = []
    for cell_notes in notes:
        copied.append(cell_notes.duplicate())
    return copied

func _editable_selection() -> bool:
    if selected_index < 0:
        status_label.text = "先にセルを選んでね。"
        return false
    if givens[selected_index]:
        status_label.text = "最初からある数字は変更できません。"
        return false
    return true

func _refresh_cells() -> void:
    for i in range(27):
        var button := cell_buttons[i]
        var value := int(values[i])
        if value != 0:
            button.text = str(value)
            button.add_theme_font_size_override("font_size", 19)
        elif not notes[i].is_empty():
            button.text = _notes_text(notes[i])
            button.add_theme_font_size_override("font_size", 9)
        else:
            button.text = ""
            button.add_theme_font_size_override("font_size", 19)

        button.modulate = Color.WHITE
        if givens[i]:
            button.modulate = Color("e9eef8")
        if selected_index >= 0 and i != selected_index and _same_plane(i, selected_index):
            button.modulate = Color("dff7fb")
        if _cell_has_conflict(i):
            button.modulate = Color("ffd7d7")
        if i == selected_index:
            button.modulate = Color("91dbef")

func _notes_text(cell_notes: Array) -> String:
    var out := ""
    for digit in DIGITS:
        out += str(digit) if digit in cell_notes else "·"
        if digit % 3 == 0 and digit != 9:
            out += "\n"
        elif digit % 3 != 0:
            out += " "
    return out

func _check_board() -> void:
    if _has_any_conflict():
        status_label.text = "同じ断面に同じ数字がある。"
        return
    if 0 in values:
        status_label.text = "矛盾なし。まだ空きマスがある。"
        return
    if _is_valid_complete_board():
        status_label.text = "CLEAR! 9枚すべて成立。"
    else:
        status_label.text = "まだ成立していない断面がある。"

func _announce_if_complete() -> void:
    if 0 not in values and not _has_any_conflict() and _is_valid_complete_board():
        status_label.text = "CLEAR! 9枚すべて成立。"

func _has_any_conflict() -> bool:
    for i in range(27):
        if _cell_has_conflict(i):
            return true
    return false

func _cell_has_conflict(index: int) -> bool:
    var value := int(values[index])
    if value == 0:
        return false
    for other in range(27):
        if other != index and int(values[other]) == value and _same_plane(index, other):
            return true
    return false

func _is_valid_complete_board() -> bool:
    for axis in range(3):
        for plane in range(3):
            var seen := {}
            for i in range(27):
                var c := _coords(i)
                var coordinate := c.x if axis == 0 else (c.y if axis == 1 else c.z)
                if coordinate == plane:
                    var value := int(values[i])
                    if value < 1 or value > 9 or seen.has(value):
                        return false
                    seen[value] = true
            if seen.size() != 9:
                return false
    return true

func _same_plane(a: int, b: int) -> bool:
    var ca := _coords(a)
    var cb := _coords(b)
    return ca.x == cb.x or ca.y == cb.y or ca.z == cb.z

func _coords(index: int) -> Vector3i:
    var x := index / 9
    var rem := index % 9
    var y := rem / 3
    var z := rem % 3
    return Vector3i(x, y, z)

func _unhandled_key_input(event: InputEvent) -> void:
    if not event is InputEventKey:
        return
    var key_event := event as InputEventKey
    if not key_event.pressed or key_event.echo:
        return
    if key_event.ctrl_pressed and key_event.keycode == KEY_Z:
        _undo()
        get_viewport().set_input_as_handled()
        return
    if key_event.keycode == KEY_BACKSPACE or key_event.keycode == KEY_DELETE:
        _erase_selected()
        get_viewport().set_input_as_handled()
        return
    if key_event.unicode >= 49 and key_event.unicode <= 57:
        _input_digit(int(key_event.unicode - 48))
        get_viewport().set_input_as_handled()

func _show_fatal(message: String) -> void:
    var label := Label.new()
    label.text = message
    label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    add_child(label)

extends RefCounted

const STAGE_DATA_PATH := "res://data/stages_001_020.json"

var pack: Dictionary = {}
var stages_by_id: Dictionary = {}

func load_pack() -> bool:
    if not FileAccess.file_exists(STAGE_DATA_PATH):
        return false
    var text := FileAccess.get_file_as_string(STAGE_DATA_PATH)
    var parsed = JSON.parse_string(text)
    if typeof(parsed) != TYPE_DICTIONARY:
        return false
    if not parsed.has("stages") or typeof(parsed["stages"]) != TYPE_ARRAY:
        return false
    pack = parsed
    stages_by_id.clear()
    for stage in pack["stages"]:
        if typeof(stage) == TYPE_DICTIONARY and stage.has("id"):
            stages_by_id[String(stage["id"])] = stage
    return not stages_by_id.is_empty()

func get_stage(id: String) -> Dictionary:
    if stages_by_id.has(id):
        return stages_by_id[id].duplicate(true)
    return {}

func get_all_stage_ids() -> Array[String]:
    var ids: Array[String] = []
    for stage in pack.get("stages", []):
        ids.append(String(stage["id"]))
    return ids

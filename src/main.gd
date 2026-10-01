extends Control

const STAGE_DATA_PATH := "res://data/stages_001_020.json"

func _ready() -> void:
    var status: Label = $Margin/VBox/Status
    if FileAccess.file_exists(STAGE_DATA_PATH):
        status.text = "Tutorial data ready · 20 stages"
    else:
        status.text = "Tutorial data missing"

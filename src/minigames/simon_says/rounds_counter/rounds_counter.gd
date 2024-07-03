extends HBoxContainer

class_name RoundsCounter

var _round_status_list: Array[RoundStatus] = []
@export var max_rounds: int = 0
@onready var _round_status_scene = preload("res://src/minigames/simon_says/rounds_counter/round_status.tscn")

func _ready():
    for _i in range(max_rounds):
        var round_status: RoundStatus = _round_status_scene.instantiate() as RoundStatus
        _round_status_list.append(round_status)
        add_child(round_status)

func set_current_round(round_number: int, round_status: RoundStatus.Status):
    _round_status_list[round_number].set_current_status(round_status)
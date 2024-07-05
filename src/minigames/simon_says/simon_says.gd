extends Minigame

class_name SimonSaysMinigame

@onready var _buttons: Buttons = $Buttons
@onready var _block_control: Control = $BlockControl
@onready var _attention_background: ColorRect = $AttentionBackground
@onready var _rounds_counter: RoundsCounter = $RoundsCounter
@onready var _minigame_ended_message_scene: PackedScene = preload("res://src/common/messages/minigame_ended_message.tscn")

@export var max_rounds: int = 0
var _played_sequence: Array[ButtonColor] = []
var _played_correctly: bool = true

enum ButtonColor {BLUE, GREEN, RED, YELLOW}

var _sequence: Array[ButtonColor] = []
var current_round = 0
const colors: Array[ButtonColor] = [ButtonColor.BLUE, ButtonColor.GREEN, ButtonColor.RED, ButtonColor.YELLOW]

func _ready() -> void:
    _block_control.visible = true
    await _new_round()

func add_to_sequence(color: ButtonColor):
    _sequence.append(color)

func _on_buttons_color_selected(color: ButtonColor):
    _played_sequence.append(color)

    if(_played_sequence[_played_sequence.size() - 1] != _sequence[_played_sequence.size() - 1]):
        await _buttons.play_on_wrong_sequence()

    if _played_sequence.size() == _sequence.size():
        _played_correctly = _played_sequence == _sequence
        _played_sequence = []
        _block_control.visible = true
        await get_tree().create_timer(0.5).timeout
        if _played_correctly:
            await _buttons.play_on_correct_sequence()
        else:
            await get_tree().create_timer(0.5).timeout
        await _new_round()
        return
    
    _played_correctly = _played_correctly and _played_sequence == _sequence.slice(0, _played_sequence.size())

func _new_round():
    if current_round > 0:
        if _played_correctly:
            _rounds_counter.set_current_round(current_round - 1, RoundStatus.Status.WON)
        else:
            _rounds_counter.set_current_round(current_round - 1, RoundStatus.Status.LOST)

    if current_round >= max_rounds:
        await _show_win_message()
        minigame_ended.emit()
        return

    current_round += 1
    add_to_sequence(colors.pick_random())

    var attention_background_tween = get_tree().create_tween()
    attention_background_tween.tween_property(_attention_background, "color", Color(0, 0, 0, 0.25), 0.25)
    await attention_background_tween.finished
    
    await _buttons.play_sequence(_sequence)

    attention_background_tween = get_tree().create_tween()
    attention_background_tween.tween_property(_attention_background, "color", Color(0, 0, 0, 0), 0.25)
    await attention_background_tween.finished
    _block_control.visible = false

func _show_win_message():
    var minigame_ended_message: MinigameEndedMessage = _minigame_ended_message_scene.instantiate()
    minigame_ended_message.main_text = "¡Bien hecho!"
    minigame_ended_message.message_text = "Ha sido una excelente partida."
    add_child(minigame_ended_message)
    await minigame_ended_message.animation_tween().finished
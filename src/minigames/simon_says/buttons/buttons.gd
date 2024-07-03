extends GridContainer

class_name Buttons

@onready var _blue_button: SequenceButton = $BlueSequenceButton
@onready var _green_button: SequenceButton = $GreenSequenceButton
@onready var _red_button: SequenceButton = $RedSequenceButton
@onready var _yellow_button: SequenceButton = $YellowSequenceButton

signal color_selected(color: SimonSaysMinigame.ButtonColor)

@onready var _buttons_colors = {
    SimonSaysMinigame.ButtonColor.BLUE: _blue_button,
    SimonSaysMinigame.ButtonColor.GREEN: _green_button,
    SimonSaysMinigame.ButtonColor.RED: _red_button,
    SimonSaysMinigame.ButtonColor.YELLOW: _yellow_button
}

func play_sequence(sequence: Array[SimonSaysMinigame.ButtonColor]):
    for color in sequence:
        await _buttons_colors[color].play_active_animation()
        await get_tree().create_timer(0.2).timeout

func _on_green_sequence_button_pressed():
    color_selected.emit(SimonSaysMinigame.ButtonColor.GREEN)

func _on_yellow_sequence_button_pressed():
    color_selected.emit(SimonSaysMinigame.ButtonColor.YELLOW)

func _on_red_sequence_button_pressed():
    color_selected.emit(SimonSaysMinigame.ButtonColor.RED)

func _on_blue_sequence_button_pressed():
    color_selected.emit(SimonSaysMinigame.ButtonColor.BLUE)

func play_on_wrong_sequence():
    var tween = create_tween().set_parallel(true)
    tween.tween_property(self, "position", position + Vector2(2, 0), 0.1).set_trans(Tween.TRANS_SINE)
    tween.tween_property(self, "position", position - Vector2(4, 0), 0.2).set_trans(Tween.TRANS_SINE).set_delay(0.1)
    tween.tween_property(self, "position", position + Vector2(2, 0), 0.1).set_trans(Tween.TRANS_SINE).set_delay(0.3)
    
    tween.tween_property(self, "modulate", Color(0.5, 0.5, 0.5, 1), 0.2).set_trans(Tween.TRANS_SINE)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1).set_trans(Tween.TRANS_SINE).set_delay(0.2)
    await tween.finished

func play_on_correct_sequence():
    for button in _buttons_colors.values():
        button.change_to_active_texture()

    await get_tree().create_timer(0.5).timeout

    for button in _buttons_colors.values():
        button.change_to_idle_texture()

    await get_tree().create_timer(0.5).timeout
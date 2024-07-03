extends Control

class_name TitleScreen

signal start_game_requested

func _on_texture_button_pressed():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate", Color(0, 0, 0, 1), 1)
	await get_tree().create_timer(0.5).timeout
	await tween.finished
	start_game_requested.emit()

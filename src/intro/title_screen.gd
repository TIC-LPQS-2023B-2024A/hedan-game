extends Control

class_name TitleScreen

signal start_game_requested

@onready var _texture_button: TextureButton = $TextureButton

func _on_texture_button_pressed():
	_texture_button.disabled = true
	_texture_button.pressed.disconnect(_on_texture_button_pressed)
	SfxPlayer.play_sfx("start.mp3", -10)
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate", Color(0, 0, 0, 1), 1)
	await get_tree().create_timer(0.5).timeout
	await tween.finished
	start_game_requested.emit()

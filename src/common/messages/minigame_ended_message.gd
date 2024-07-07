extends Control

class_name MinigameEndedMessage

@export var main_text = ""
@export var message_text = ""

@onready var _main_text_label: Label = $MainText
@onready var _message_text_label: Label = $MessageText

func _ready() -> void:
    _main_text_label.text = main_text
    _message_text_label.text = message_text
    pivot_offset = size / 2
    scale = Vector2(0, 0)

func animation_tween() -> Tween:
    SfxPlayer.play_sfx("win.mp3", -8)
    var tween = get_tree().create_tween().set_parallel(true)
    tween.tween_property(self, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    tween.tween_property(self, "scale", Vector2(1, 1), 5).set_delay(0.3)
    tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(5.3)
    tween.tween_property(self, "modulate:a", 0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(5.3)
    return tween

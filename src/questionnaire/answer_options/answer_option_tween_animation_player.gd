extends TweenAnimationPlayer

class_name AnswerOptionTweenAnimationPlayer

@onready var _parent = get_parent()

func idle_to_unselected_animation(tween: Tween):
	tween.tween_property(self._parent, "scale", Vector2(0.9, 0.9), 0.08).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self._parent, "modulate", Color(1, 1, 1, 0.4), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func idle_to_hover_animation(tween: Tween):
	tween.tween_property(self._parent, "scale", Vector2(1.1, 1.1), 0.08).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self._parent, "modulate", Color(1, 1, 1, 1), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func hover_to_idle_animation(tween: Tween):
	tween.tween_property(self._parent, "scale", Vector2(1.0, 1.0), 0.08).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self._parent, "modulate", Color(1, 1, 1, 0.85), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func hover_to_button_down_animation(tween: Tween):
	tween.tween_property(self._parent, "scale", Vector2(1, 1), 0.02).set_trans(Tween.TRANS_SINE)

func button_down_to_button_up_animation(tween: Tween):
	tween.tween_property(self._parent, "scale", Vector2(1.2, 1.2), 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self._parent, "modulate", Color(1.05, 1.05, 1.05, 1), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self._parent, "modulate", Color(1, 1, 1, 1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(0.4)

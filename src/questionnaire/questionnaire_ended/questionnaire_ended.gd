extends Label

class_name QuestionnaireEnded

func _ready():
	self.position.y = - get_viewport_rect().size.y

func entry_animation_tween() -> Tween:
	SfxPlayer.play_sfx("win.mp3", -8)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", 0, 0.5).set_trans(Tween.TRANS_SINE)
	return tween

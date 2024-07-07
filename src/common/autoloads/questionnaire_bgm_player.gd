extends AudioStreamPlayer2D

func play_bgm() -> void:
    volume_db = 0
    play()

func volume_down(fade_duration: float) -> void:
    var tween = get_tree().create_tween().set_parallel(true)
    tween.tween_property(self, "volume_db", -80, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    await tween.finished
    await get_tree().create_timer(0.5).timeout

func volume_up(fade_duration: float) -> void:
    var tween = get_tree().create_tween().set_parallel(true)
    tween.tween_property(self, "volume_db", 0, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    await tween.finished

func _on_finished():
    await get_tree().create_timer(0.5).timeout
    play()


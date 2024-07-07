extends AudioStreamPlayer2D

const _bgm_src = "res://assets/bgm/"

func play_bgm(bgm_name: String) -> void:
    volume_db = 0
    var path = _bgm_src + bgm_name
    var streamToPlay: AudioStream = load(path)
    stream = streamToPlay
    play()

func stop_bgm(fade_duration: float) -> void:
    var tween = get_tree().create_tween().set_parallel(true)
    tween.tween_property(self, "volume_db", -80, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    await tween.finished
    await get_tree().create_timer(0.5).timeout
    stop()


func _on_finished():
    await get_tree().create_timer(0.5).timeout
    play()

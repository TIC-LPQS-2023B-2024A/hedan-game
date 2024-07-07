extends TextureButton

class_name SequenceButton

var _tween = null
var _original_idle_texture: Texture = null
@export var active_texture: Texture = null

func _ready():
    pivot_offset = size / 2
    _original_idle_texture = texture_normal

func play_active_animation():

    if _tween != null:
        _tween.kill()
        scale = Vector2(1, 1)
        modulate = Color(1, 1, 1, 1)

    texture_normal = active_texture
    _tween = get_tree().create_tween().set_parallel(true)
    _tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_SINE)
    _tween.tween_property(self, "modulate", Color(1.1, 1.1, 1.1, 1.1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    _tween.tween_property(self, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_SINE).set_delay(0.3)
    _tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(0.3)
    await _tween.finished
    texture_normal = _original_idle_texture

func _on_pressed():
    await play_active_animation()

func change_to_idle_texture():
    texture_normal = _original_idle_texture

func change_to_active_texture():
    texture_normal = active_texture
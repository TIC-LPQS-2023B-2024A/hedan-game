extends Node

class_name TweenManager

@export var tween_animation_player: TweenAnimationPlayer = null

func play_animation(animation_name: String) -> Tween:
    var parent = get_parent() as Node
    if parent == null or not parent.is_inside_tree():
        return

    if tween_animation_player == null:
        return

    if tween_animation_player.has_method(animation_name) == false:
        return

    var tween = get_parent().create_tween().set_parallel(true)
    tween_animation_player.call(animation_name, tween)
    return tween

extends AnimatableBody2D

class_name Coin

@export var fall_speed: float = 0

func _process(delta):
    position.y += fall_speed * delta
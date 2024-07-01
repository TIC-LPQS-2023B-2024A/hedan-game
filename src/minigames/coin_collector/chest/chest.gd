extends Area2D

class_name Chest

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

signal opened
signal coin_collected

func _on_animated_sprite_2d_animation_finished():
    if _animated_sprite.animation == "opening":
        opened.emit()

func open_chest():
    _animated_sprite.play("opening")

func _on_body_entered(body: Node2D):
    if body is Coin:
        _handle_coin(body)
        return

func _handle_coin(coin: Coin):
    _animation_player.play("get_coin")
    coin.queue_free()
    coin_collected.emit()

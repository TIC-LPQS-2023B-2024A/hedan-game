extends Node2D

class_name CoinGenerator

@onready var _coin_scene: PackedScene = preload ("res://src/minigames/coin_collector/coin/coin.tscn")
@export var min_distance_between_coins = 0.0
@export var max_distance_between_coins = 0.0
@export var coin_fall_speed = 0.0
var _past_coin_position_x: float = 0.0

func _ready() -> void:
    _past_coin_position_x = randf_range(200, get_viewport_rect().size.x - 200)

func _on_timer_timeout() -> void:
    var coin: Coin = _coin_scene.instantiate()
    var left_or_right = -1 if randi_range(0, 1) % 2 == 0 else 1
    var position_on_x = _past_coin_position_x + (left_or_right * randf_range(min_distance_between_coins, max_distance_between_coins))
    
    if position_on_x < 200 or position_on_x > get_viewport_rect().size.x - 200:
        position_on_x = (2 * _past_coin_position_x) - position_on_x

    position_on_x = clamp(position_on_x, 200, get_viewport_rect().size.x - 200)
    
    _past_coin_position_x = position_on_x
    coin.position = Vector2(position_on_x, -150)
    coin.fall_speed = coin_fall_speed
    add_child(coin)

func start_coins_spawn() -> void:
    $Timer.start()
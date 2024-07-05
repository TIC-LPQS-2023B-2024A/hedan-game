extends Node2D

class_name CoinCollectorMain2D

@onready var _chest: Chest = $Chest
@onready var _coin_generator: CoinGenerator = $CoinGenerator
@export var coins_to_collect: int = 0
var _score = 0
var _following_mouse = true

signal all_coins_collected
signal score_updated(score: int)

func _ready():
    _chest.coin_collected.connect(_on_chest_coin_collected)
    _chest.position.x = get_viewport().get_mouse_position().x
    _chest.open_chest()

func _process(_delta):
    if !_following_mouse:
        return

    _chest.position.x = clamp(
        get_viewport().get_mouse_position().x,
        128.0,
        get_viewport_rect().size.x - (128)
    )

func _on_chest_opened():
    _coin_generator.start_coins_spawn()

func _on_chest_coin_collected():
    if _score == coins_to_collect:
        all_coins_collected.emit()
        _following_mouse = false
        _chest.coin_collected.disconnect(_on_chest_coin_collected)
        await _coin_generator.stop_coins_spawn()
        _coin_generator.queue_free()
        return

    _score += 1
    score_updated.emit(_score)
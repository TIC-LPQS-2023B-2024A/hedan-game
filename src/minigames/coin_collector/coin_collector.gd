extends Minigame

@onready var _score_label: Label = $ScoreContainer/Score
@onready var _total_label: Label = $ScoreContainer/Total
@onready var _coin_collector_main_2d: CoinCollectorMain2D = $CoinCollectorMain2D
@onready var _minigame_ended_message_scene: PackedScene = preload("res://src/common/messages/minigame_ended_message.tscn")

func _ready():
	_total_label.text = "%d" % _coin_collector_main_2d.coins_to_collect
	_score_label.text = "%d" % 0

func _on_coin_collector_main_2d_all_coins_collected():
	await _show_win_message()
	minigame_ended.emit()

func _on_coin_collector_main_2d_score_updated(score:int):
	_score_label.text = "%d" % (score)

func _show_win_message():
	BgmPlayer.stop_bgm(1.5)
	var minigame_ended_message: MinigameEndedMessage = _minigame_ended_message_scene.instantiate()
	minigame_ended_message.main_text = "¡Genial!"
	minigame_ended_message.message_text = "Has recolectado muchas monedas."
	add_child(minigame_ended_message)
	await minigame_ended_message.animation_tween().finished
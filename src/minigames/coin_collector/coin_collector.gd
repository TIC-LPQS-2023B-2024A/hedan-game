extends Minigame

@onready var _score_label: Label = $ScoreContainer/Score
@onready var _total_label: Label = $ScoreContainer/Total
@onready var _coin_collector_main_2d: CoinCollectorMain2D = $CoinCollectorMain2D

func _ready():
	_total_label.text = "%d" % _coin_collector_main_2d.coins_to_collect
	_score_label.text = "%d" % 0

func _on_coin_collector_main_2d_all_coins_collected():
	minigame_ended.emit()

func _on_coin_collector_main_2d_score_updated(score:int):
	_score_label.text = "%d" % (score)

extends TextureRect

class_name QuestionnaireProgressBar

@onready var _nine_patch_rect: NinePatchRect = $NinePatchRect

var _total_size: float = 0.0

func _ready():
	_nine_patch_rect.custom_minimum_size.x = 0
	_total_size = self.size.x - 20

func set_percent(percent: float):
	_nine_patch_rect.custom_minimum_size.x  = _total_size * percent 

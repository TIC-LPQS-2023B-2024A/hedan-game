extends TextureRect

class_name RoundStatus

enum Status {UNDEFINED, WON, LOST}

var _current_status = Status.UNDEFINED
@onready var _color_rect_1: ColorRect = $ColorRect
@onready var _color_rect_2: ColorRect = $ColorRect2
@onready var _color_rect_3: ColorRect = $ColorRect3

var _status_colors = {
    Status.UNDEFINED: Color(0.419813, 0.419813, 0.419813, 1),
    Status.WON: Color(0.3, 0.55, 0.2, 1),
    Status.LOST: Color(0.75, 0.13, 0.13, 1)
}

func set_current_status(status: Status):
    _current_status = status
    _color_rect_1.color = _status_colors[status]
    _color_rect_2.color = _status_colors[status]
    _color_rect_3.color = _status_colors[status]
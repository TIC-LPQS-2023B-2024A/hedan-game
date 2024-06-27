extends HBoxContainer

class_name AnswerOptionsContainer

@onready var _yes_option: AnswerOption = $YesOption
@onready var _no_option: AnswerOption = $NoOption
signal answer_selected(answer: bool)
var _is_hovering_yes_option: bool = false
var _is_hovering_no_option: bool = false

func _ready():
    _yes_option.connect("mouse_entered", _on_yes_option_mouse_entered)
    _no_option.connect("mouse_entered", _on_no_option_mouse_entered)
    _yes_option.connect("mouse_exited", _on_option_mouse_exited)
    _no_option.connect("mouse_exited", _on_option_mouse_exited)
    _yes_option.pressed.connect(_on_yes_option_pressed)
    _no_option.pressed.connect(_on_no_option_pressed)
    _yes_option.uninterruptible_animation.connect(_on_option_uninterruptible_animation)
    _no_option.uninterruptible_animation.connect(_on_option_uninterruptible_animation)

func _on_yes_option_mouse_entered():
    self._is_hovering_yes_option = true
    _no_option.play_idle_to_unselected_animation()

func _on_no_option_mouse_entered():
    self._is_hovering_no_option = true
    _yes_option.play_idle_to_unselected_animation()

func _on_option_mouse_exited():
    self._is_hovering_yes_option = false
    self._is_hovering_no_option = false
    _yes_option.play_hover_to_idle_animation()
    _no_option.play_hover_to_idle_animation()

func _on_yes_option_pressed():
    answer_selected.emit(true)

func _on_no_option_pressed():
    answer_selected.emit(false)

func _on_option_uninterruptible_animation(is_in_uninterruptible_animation: bool):
    _yes_option.is_in_uninterruptible_animation = is_in_uninterruptible_animation
    _no_option.is_in_uninterruptible_animation = is_in_uninterruptible_animation

    if is_in_uninterruptible_animation:
        _yes_option.pressed.disconnect(_on_yes_option_pressed)
        _no_option.pressed.disconnect(_on_no_option_pressed)
    else:
        _yes_option.pressed.connect(_on_yes_option_pressed)
        _no_option.pressed.connect(_on_no_option_pressed)

    if is_in_uninterruptible_animation:
        return

    if self._is_hovering_yes_option:
        _yes_option.play_idle_to_hover_animation()
        _no_option.play_idle_to_unselected_animation()
    elif self._is_hovering_no_option:
        _no_option.play_idle_to_hover_animation()
        _yes_option.play_idle_to_unselected_animation()
    else:
        _yes_option.play_hover_to_idle_animation()
        _no_option.play_hover_to_idle_animation()

func disable_options():
    _yes_option.disabled = true
    _no_option.disabled = true
    _yes_option.set_mouse_filter(MOUSE_FILTER_IGNORE)
    _no_option.set_mouse_filter(MOUSE_FILTER_IGNORE)
    self.set_mouse_filter(MOUSE_FILTER_IGNORE)

func enable_options():
    _yes_option.disabled = false
    _no_option.disabled = false
    _yes_option.set_mouse_filter(MOUSE_FILTER_STOP)
    _no_option.set_mouse_filter(MOUSE_FILTER_STOP)
    self.set_mouse_filter(MOUSE_FILTER_STOP)
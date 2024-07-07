extends Control

class_name MinigameTutorial

signal tutorial_ended

@export var minigame_name: String
@export var minigame_video: VideoStream
@export var how_to_play_text: String
@export var goal_text: String

@onready var _how_to_play_label: Label = $GuiPanel/VBoxContainer/VBoxContainer/HowToPlayLabel
@onready var _goal_label: Label = $GuiPanel/VBoxContainer/GoalLabel
@onready var _gui_button: TextureButton = $GuiPanel/GuiButton

func _ready():
    ($GuiPanel/Ribbon/Label as Label).text = minigame_name
    ($Video/VideoStreamPlayer as VideoStreamPlayer).stream = minigame_video
    ($Video/VideoStreamPlayer as VideoStreamPlayer).play()
    $GuiPanel.position.y = -get_viewport_rect().size.y
    $Video.modulate.a = 0
    _how_to_play_label.text = how_to_play_text
    _goal_label.text = goal_text

func play_intro_tween() -> Tween:
    var tween = create_tween().set_parallel(true)
    tween.tween_property($GuiPanel, "position:y", 139, 0.5)
    tween.tween_property($Video, "modulate:a", 1, 0.5).set_delay(0.5)
    return tween

func outro_tween() -> Tween:
    var tween = create_tween().set_parallel(true)
    tween.tween_property(self, "modulate:a", 0, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
    return tween

func _on_gui_button_pressed():
    SfxPlayer.play_sfx("start.mp3", -10)
    tutorial_ended.emit()
    _gui_button.disabled = true
    _gui_button.remove_child($GuiPanel/GuiButton/CursorChanger)
    _gui_button.pressed.disconnect(_on_gui_button_pressed)


extends Control

class_name Onboarding

signal onboarding_ended

@onready var _first_instruction: Label = $GuiPanel/FirstInstruction
@onready var _second_instruction: Label = $GuiPanel/SecondInstruction
@onready var _third_instruction: Label = $GuiPanel/ThirdInstruction
@onready var _block_control: Control = $BlockControl
@onready var _next_button_label: Label = $GuiPanel/NextButton/Label
@onready var _next_button: TextureButton = $GuiPanel/NextButton

var _instructions: Array[Label] = []

var _current_instruction: int = 0

func _ready() -> void:
	_instructions = [
		_first_instruction,
		_second_instruction,
		_third_instruction
	]
	for instruction in _instructions:
		instruction.visible = false
		instruction.modulate.a = 0
	modulate.a = 0
	_block_control.visible = true

	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	_instructions[_current_instruction].visible = true
	tween = get_tree().create_tween()
	tween.tween_property(_instructions[_current_instruction], "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE)
	await tween.finished

	_block_control.visible = false

func _on_next_button_pressed():
	_update_text_label()

	_play_button_sfx()

	_block_control.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(_instructions[_current_instruction], "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE)
	await tween.finished

	if _current_instruction == _instructions.size() - 1:
		onboarding_ended.emit()
		_next_button.disabled = true
		_next_button.pressed.disconnect(_on_next_button_pressed)
		return

	_current_instruction += 1
	_instructions[_current_instruction].visible = true
	tween = get_tree().create_tween()
	tween.tween_property(_instructions[_current_instruction], "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE)
	await tween.finished

	_block_control.visible = false

func _play_button_sfx() -> void:
	SfxPlayer.play_sfx("button.mp3", -5)

func _update_text_label():
	if _current_instruction == _instructions.size() - 2:
		_next_button_label.text = "¡Empecemos!"
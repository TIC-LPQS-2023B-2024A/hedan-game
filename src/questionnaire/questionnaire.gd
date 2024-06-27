extends Control

class_name Questionnaire

@onready var _answer_options_container: AnswerOptionsContainer = $AnswerOptionsContainer
@onready var _question_container: QuestionContainer = $QuestionContainer
@onready var _minigame_start_message_container_scene = preload ("res://src/questionnaire/minigame_start_message_container/minigame_start_message_container.tscn")
@onready var _block_control: Control = $BlockControl

var _questions: Array[String] = []
var _current_question = 0
var _answers: Array[Dictionary] = []
var _start_time: int = 0

@export var minigames: Array[PackedScene] = [
	preload ("res://src/minigames/memory/memory.tscn"),
	preload ("res://src/minigames/coin_collector/coin_collector.tscn"),
	preload ("res://src/minigames/tic_tac_toe/tic_tac_toe.tscn"),
	preload ("res://src/minigames/simon_says/simon_says.tscn"),
]

const _minigame_breakpoints: Array[int] = [10, 20, 30, 40]
var _current_breakpoint: int = 0
var _current_minigame: Minigame = null

signal questions_answered(answers: Array[Dictionary])

func _ready():
	_questions = _parse_csv_to_questions("res://assets/resources/cmasr-2_preguntas.txt")
	_question_container.set_initial_question(_questions[0])
	_answer_options_container.answer_selected.connect(_on_option_pressed)
	await play_intro_tween()
	_start_time = Time.get_ticks_msec()
	_question_container.question_changed.connect(_on_question_changed)
	_block_control.visible = false

func _parse_csv_to_questions(file_path: String) -> Array[String]:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var questions_array: Array[String] = []

	while !file.eof_reached():
		var line = file.get_csv_line()
		questions_array.append(line[0])
	
	file.close()
	return questions_array

func _change_to_next_question(answer: bool):
	var end_time = Time.get_ticks_msec()
	var time_taken = end_time - _start_time
	_start_time = end_time

	_answers.append({
		"questionId": _current_question + 1,
		"answer": answer,
		"timeTaken": time_taken
	})

	if _current_breakpoint < _minigame_breakpoints.size() and _current_question + 1 == _minigame_breakpoints[_current_breakpoint]:
		start_minigame()

	_current_question += 1
	if _current_question >= _questions.size():
		questions_answered.emit(_answers)
		return
	_question_container.set_question(_questions[_current_question])

func _on_option_pressed(answer: bool):
	_change_to_next_question(answer)

func play_intro_tween():
	_answer_options_container.modulate = Color(1, 1, 1, 0)
	_question_container.modulate = Color(1, 1, 1, 0)

	_answer_options_container.disable_options()

	var intro_tween = create_tween().set_parallel(true)
	intro_tween.tween_property(_answer_options_container, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	intro_tween.tween_property(_question_container, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_delay(0.5)
	await intro_tween.finished

	_answer_options_container.enable_options()

func start_minigame():
	_block_control.visible = true
	var minigame_start_message = _minigame_start_message_container_scene.instantiate()
	minigame_start_message.position = Vector2(0, 0)
	add_child(minigame_start_message)
	await get_tree().create_timer(5).timeout

	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", -get_viewport().size.y - 500, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await tween.finished
	minigame_start_message.queue_free()

	_current_breakpoint += 1
	_current_minigame = minigames[_current_breakpoint - 1].instantiate()
	_current_minigame.position.y = get_viewport().size.y + 500
	_current_minigame.minigame_ended.connect(_on_minigame_ended)
	_current_minigame.modulate = Color(1, 1, 1, 0)
	add_child(_current_minigame)

	var minigame_tween = create_tween().set_parallel(true)
	minigame_tween.tween_property(_current_minigame, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)

func _on_question_changed():
	_start_time = Time.get_ticks_msec()

func _on_minigame_ended():
	if _current_minigame != null:
		_current_minigame.queue_free()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", 0, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await tween.finished
	_block_control.visible = false
	_start_time = Time.get_ticks_msec()
extends Control

class_name Questionnaire

@onready var _answer_options_container: AnswerOptionsContainer = $AnswerOptionsContainer
@onready var _question_container: QuestionContainer = $QuestionContainer
@onready var _minigame_start_message_container_scene = preload ("res://src/questionnaire/minigame_start_message_container/minigame_start_message_container.tscn")
@onready var _onboarding_scene = preload ("res://src/questionnaire/onboarding/onboarding.tscn")
@onready var _block_control: Control = $BlockControl
@onready var _progress_bar: QuestionnaireProgressBar = $ProgressBar
@onready var _minigame_container: Control = $MinigameContainer

@onready var _questionnaire_ended_scene = preload ("res://src/questionnaire/questionnaire_ended/questionnaire_ended.tscn")

var _questions: Array[String] = []
var _current_question = 0
var _answers: Array[Dictionary] = []
var _start_time: int = 0

var _minigames: Array[String] = MinigamesConstants.minigames

var _current_breakpoint: int = 0
var _current_minigame_name: String
var _current_minigame: Minigame = null
var _current_minigame_tutorial: MinigameTutorial = null
@onready var _minigame_tutorial_scene = preload ("res://src/common/minigame_tutorial/minigame_tutorial.tscn")

signal questions_answered(answers: Array[Dictionary])
signal outro_played

func _ready():
	modulate = Color(0, 0, 0, 1)
	_answer_options_container.modulate = Color(1, 1, 1, 0)
	_question_container.modulate = Color(1, 1, 1, 0)
	_progress_bar.modulate.a = 0

	_answer_options_container.disable_options()
	
	_questions = _parse_csv_to_questions("res://assets/resources/cmasr-2_preguntas.txt")
	_question_container.set_initial_question(_questions[0])
	_answer_options_container.answer_selected.connect(_on_option_pressed)

	var intro_tween = create_tween().set_parallel(false)
	intro_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	await intro_tween.finished

	add_child(_onboarding_scene.instantiate())
	($Onboarding as Onboarding).onboarding_ended.connect(_on_onboarding_ended)

func _parse_csv_to_questions(file_path: String) -> Array[String]:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var questions_array: Array[String] = []

	while !file.eof_reached():
		var line = file.get_csv_line()
		questions_array.append(line[0])
	
	file.close()
	return questions_array

func _on_onboarding_ended():
	var onboarding_ended_tween = create_tween().set_parallel(false)
	onboarding_ended_tween.tween_property($Onboarding, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE)
	await onboarding_ended_tween.finished
	$Onboarding.queue_free()

	await play_intro_tween()
	_start_time = Time.get_ticks_msec()
	_question_container.question_changed.connect(_on_question_changed)
	_block_control.visible = false

func _change_to_next_question(answer: bool):
	var end_time = Time.get_ticks_msec()
	var time_taken = end_time - _start_time
	_start_time = end_time

	_answers.append({
		"questionId": _current_question + 1,
		"answer": answer,
		"timeTaken": time_taken
	})
	
	_progress_bar.set_percent(float(_current_question) / float(_questions.size()))

	if _current_breakpoint < MinigamesConstants.minigame_breakpoints.size() and _current_question + 1 == MinigamesConstants.minigame_breakpoints[_current_breakpoint]:
		_start_minigame_tutorial()

	_current_question += 1
	if _current_question >= _questions.size():
		questions_answered.emit(_answers)
		await _play_outro_animation()
		return
	_question_container.set_question(_questions[_current_question])

func _on_option_pressed(answer: bool):
	_change_to_next_question(answer)

func play_intro_tween():
	var intro_tween = create_tween().set_parallel(true)
	intro_tween.tween_property(_answer_options_container, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	intro_tween.tween_property(_question_container, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_delay(0.5)
	intro_tween.tween_property(_progress_bar, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE).set_delay(0.5)
	await intro_tween.finished

	_answer_options_container.enable_options()

func _start_minigame_tutorial():
	_block_control.visible = true
	var minigame_start_message = _minigame_start_message_container_scene.instantiate()
	minigame_start_message.position = Vector2(0, 0)
	add_child(minigame_start_message)
	await get_tree().create_timer(4).timeout

	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", -get_viewport_rect().size.y - 50, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await tween.finished
	minigame_start_message.queue_free()

	_current_breakpoint += 1
	_current_minigame_name = _minigames[_current_breakpoint - 1]
	
	_current_minigame_tutorial = _minigame_tutorial_scene.instantiate()
	_current_minigame_tutorial.minigame_name = MinigamesConstants.minigames_names[_current_minigame_name]
	_current_minigame_tutorial.minigame_video = MinigamesConstants.minigames_tutorial_videos[_current_minigame_name]
	_current_minigame_tutorial.how_to_play_text = MinigamesConstants.minigames_how_to_play_texts[_current_minigame_name]
	_current_minigame_tutorial.goal_text = MinigamesConstants.minigames_goals_texts[_current_minigame_name]
	_current_minigame_tutorial.tutorial_ended.connect(_on_minigame_tutorial_ended)

	_minigame_container.add_child(_current_minigame_tutorial)
	await _current_minigame_tutorial.play_intro_tween().finished
	_block_control.visible = false

func _start_current_minigame():
	_current_minigame = MinigamesConstants.minigames_packed_scenes[_current_minigame_name].instantiate()
	_current_minigame.minigame_ended.connect(_on_minigame_ended)
	_current_minigame.modulate = Color(1, 1, 1, 0)
	_minigame_container.add_child(_current_minigame)

	var minigame_tween = create_tween().set_parallel(true)
	minigame_tween.tween_property(_current_minigame, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	await minigame_tween.finished

func _on_question_changed():
	_start_time = Time.get_ticks_msec()

func _on_minigame_tutorial_ended():
	await _current_minigame_tutorial.outro_tween().finished
	_current_minigame_tutorial.queue_free()
	_current_minigame_tutorial = null
	await _start_current_minigame()

func _on_minigame_ended():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", 0, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await tween.finished
	if _current_minigame != null:
		_current_minigame.queue_free()
	_block_control.visible = false
	_start_time = Time.get_ticks_msec()

func _play_outro_animation():
	_block_control.visible = true
	add_child(_questionnaire_ended_scene.instantiate())
	$QuestionnaireEnded.entry_animation_tween()
	await get_tree().create_timer(4).timeout

	var outro_tween = create_tween().set_parallel(true)
	outro_tween.tween_property(self, "position:y", -get_viewport_rect().size.y - 50, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await outro_tween.finished
	outro_played.emit()
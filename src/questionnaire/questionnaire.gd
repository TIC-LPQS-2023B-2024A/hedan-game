extends Control

class_name Questionnaire

@onready var _answer_options_container: AnswerOptionsContainer = $AnswerOptionsContainer
@onready var _question_container: QuestionContainer = $QuestionContainer

var _questions: Array[String] = []
var _current_question = 0
var _token = "dewddewdwedwdwde"
var _answers: Array[Dictionary] = []
var _start_time: int = 0

signal questions_answered

func _ready():
	_questions = _parse_csv_to_questions("res://assets/resources/cmasr-2_preguntas.txt")
	_question_container.set_initial_question(_questions[0])
	_answer_options_container.answer_selected.connect(_on_option_pressed)
	await play_intro_tween()
	_start_time = Time.get_ticks_msec()
	_question_container.question_changed.connect(_on_question_changed)

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

	_current_question += 1
	if _current_question >= _questions.size():
		questions_answered.emit()
		return
	_question_container.set_question(_questions[_current_question])

func _on_option_pressed(answer: bool):
	_change_to_next_question(answer)

func save_answers_to_json():
	var result = {
		"token": _token,
		"answers": _answers
	}
	var json_string = JSON.stringify(result)
	print(json_string)

func play_intro_tween():
	_answer_options_container.modulate = Color(1, 1, 1, 0)
	_question_container.modulate = Color(1, 1, 1, 0)

	_answer_options_container.disable_options()

	var intro_tween = create_tween().set_parallel(true)
	intro_tween.tween_property(_answer_options_container, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	intro_tween.tween_property(_question_container, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_delay(0.5)
	await intro_tween.finished

	_answer_options_container.enable_options()

func _on_question_changed():
	_start_time = Time.get_ticks_msec()
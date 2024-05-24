extends Control

class_name Questionnaire

var _questions: Array[String] = []
var _current_question = 0
@onready var _question_label: Label = $QuestionContainer/QuestionLabelContainer/QuestionLabel
signal questions_answered

func _ready():
	_questions = _parse_csv_to_questions("res://assets/resources/cmasr-2_preguntas.txt")
	_question_label.text = _questions[0]

func _parse_csv_to_questions(file_path: String) -> Array[String]:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var questions_array: Array[String] = []

	while !file.eof_reached():
		var line = file.get_csv_line()
		questions_array.append(line[0])
	
	file.close()
	return questions_array

func _change_to_next_question():
	_current_question += 1
	if _current_question >= _questions.size():
		questions_answered.emit()
		return
	_question_label.text = _questions[_current_question]

func _on_yes_option_pressed():
	_change_to_next_question()

func _on_no_option_pressed():
	_change_to_next_question()

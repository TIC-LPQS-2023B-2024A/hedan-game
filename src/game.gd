extends Node

@export var questionnaire_scene: PackedScene

func _ready():
	if questionnaire_scene != null:
		var questionnaire_scene_instance = questionnaire_scene.instantiate() as Questionnaire
		questionnaire_scene_instance.questions_answered.connect(_on_questionnaire_questions_answered)
		add_child(questionnaire_scene_instance)

func _on_questionnaire_questions_answered():
	print("All questions answered")
	print_questionnaire_answers()
	get_tree().quit()

func print_questionnaire_answers():
	var questionnaire_instance = get_node("Questionnaire") as Questionnaire
	if questionnaire_instance != null:
		questionnaire_instance.save_answers_to_json()
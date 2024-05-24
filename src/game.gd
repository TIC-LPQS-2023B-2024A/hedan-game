extends Node

@export var questionnaire_scene: PackedScene

func _ready():
	if questionnaire_scene != null:
		var questionnaire_scene_instance = questionnaire_scene.instantiate() as Questionnaire
		questionnaire_scene_instance.questions_answered.connect(_on_questionnaire_questions_answered)
		add_child(questionnaire_scene_instance)

func _on_questionnaire_questions_answered():
	get_tree().quit()

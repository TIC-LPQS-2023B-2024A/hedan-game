extends TextureButton

# Función para manejar el evento de entrada
func _on_pressed():
	change_scene()

# Función para cambiar la escena
func change_scene():
	var new_scene = load("res://src/questionnaire/questionnaire.tscn")
	get_tree().change_scene_to_packed(new_scene)
	queue_free()


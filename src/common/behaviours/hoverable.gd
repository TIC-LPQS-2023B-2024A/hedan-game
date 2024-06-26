extends Control

class_name Hoverable

var normal_cursor = preload("res://assets/cursors/Cursor.png")
var hover_cursor = preload("res://assets/cursors/hand.png")

func _ready():
    mouse_entered.connect(self._on_mouse_entered)
    mouse_exited.connect(self._on_mouse_exited)
    Input.set_custom_mouse_cursor(normal_cursor, Input.CURSOR_ARROW, Vector2(16, 10))

func _on_mouse_entered():
    Input.set_custom_mouse_cursor(hover_cursor, Input.CURSOR_ARROW, Vector2(16, 10))

func _on_mouse_exited():
    Input.set_custom_mouse_cursor(normal_cursor, Input.CURSOR_ARROW, Vector2(16, 10))
extends Node

class_name CursorChanger

@export var normal_cursor = preload ("res://assets/cursors/Cursor.png")
@export var hover_cursor = preload ("res://assets/cursors/hand.png")

func _ready():
    if get_parent() != null:
        get_parent().connect("mouse_entered", self._on_mouse_entered)
        get_parent().connect("mouse_exited", self._on_mouse_exited)
    else:
        connect("mouse_entered", self._on_mouse_entered)
        connect("mouse_exited", self._on_mouse_exited)

func _on_mouse_entered():
    Input.set_custom_mouse_cursor(hover_cursor, Input.CURSOR_ARROW, Vector2(16, 10))

func _on_mouse_exited():
    Input.set_custom_mouse_cursor(normal_cursor, Input.CURSOR_ARROW, Vector2(16, 10))
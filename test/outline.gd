extends Control

func _ready():
	Input.set_custom_mouse_cursor(preload("res://assets/img/expand.svg"))


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var position = get_viewport().get_mouse_position()
	draw_circle(position, 5, Color.WHITE)

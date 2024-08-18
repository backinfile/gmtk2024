class_name MeterialButton
extends Button

@onready var count_label := $Ring/Count as Label


func _ready():
	selected = false

var count: int = 0:
	set(value):
		count = value
		count_label.text = str(count)

var node: ShapeNode:
	set(value):
		node = value
		$Container.add_child(node)

var selected: bool = false:
	set(value):
		selected = value
		update()
	
var color: Color:
	set(value):
		color = value


var state: DrawMode:
	set(value):
		if state != value:
			state = value 
			update()


func _draw() -> void:
	state = get_draw_mode()

func update():
	var tween = create_tween()
	var color: Color 
	if selected:
		color = Color(1, 1, 1, 1)
	else:
		tween.tween_property($Container, "modulate", Color(1, 1, 1, 1), .1)
		match state:
			DrawMode.DRAW_NORMAL:
				color = Color(1, 1, 1, 0)
			DrawMode.DRAW_HOVER:
				color = Color(1, 1, 1, 1)
			DrawMode.DRAW_PRESSED:
				color = Color(1, 1, 1, .8)
			DrawMode.DRAW_DISABLED:
				tween.tween_property($Container, "modulate", Color(1, 1, 1, .5), .1)
				color = Color(1, 1, 1, 0)
			DrawMode.DRAW_HOVER_PRESSED:
				color = Color(1, 1, 1, .8)
	tween.tween_property($Border, "modulate", color, .1)

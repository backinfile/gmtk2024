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
		assert(node, "please set node first")
		$Ring.modulate = color
		$Border.modulate = color
		node.triangle_color = color

var state: DrawMode:
	set(value):
		if state != value:
			state = value 
			update()


func _draw() -> void:
	state = get_draw_mode()

func update():
	var tween = create_tween()
	var a = 1
	if selected:
		a = 1
	else:
		tween.tween_property($Container, "modulate:a", 1, .1)
		match state:
			DrawMode.DRAW_NORMAL:
				a = 0
			DrawMode.DRAW_HOVER:
				a = 1
			DrawMode.DRAW_PRESSED:
				a = .8
			DrawMode.DRAW_DISABLED:
				tween.tween_property($Container, "modulate:a", .5, .1)
				a = 0
			DrawMode.DRAW_HOVER_PRESSED:
				a = .8
	tween.tween_property($Border, "modulate:a", a, .1)

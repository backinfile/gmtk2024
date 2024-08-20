class_name MeterialButton
extends Button

@onready var count_label := $Ring/Count as Label


func _ready():
	selected = false

var count: int = 0:
	set(value):
		count = value
		count_label.text = str(count)
		if count <= 0:
			disabled = true
		else:
			disabled = false
		update()

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
		$Ring.self_modulate = color
		$Border.modulate = color
		$Ring/Count.modulate = color
		count_label.modulate = color
		node.triangle_color = color

var state: DrawMode:
	set(value):
		if state != value:
			state = value 
			update()


func _draw() -> void:
	state = get_draw_mode()

var tween: Tween
func update():
	if tween: tween.kill()
	tween = create_tween().set_parallel()
	var a = 1
	$Ring.show()
	tween.tween_property($Container, "modulate:a", 1, .1)
	if selected:
		print("seleced")
		a = 1
	else:
		match state:
			DrawMode.DRAW_NORMAL:
				a = 0
			DrawMode.DRAW_HOVER:
				a = 1
			DrawMode.DRAW_PRESSED:
				a = .8
			DrawMode.DRAW_DISABLED:
				$Ring.hide()
				tween.tween_property($Container, "modulate:a", .5, .1)
				a = 0
			DrawMode.DRAW_HOVER_PRESSED:
				a = .8
	tween.tween_property($Border, "modulate:a", a, .1)

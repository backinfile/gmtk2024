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
		modulate = Color.GRAY if not value else Color.WHITE
	
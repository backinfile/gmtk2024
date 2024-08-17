class_name ShapeNode
extends Control

var shape:ShapeObject;
var count = -1;

var dragging = false;
var draggable = false;
var onDrag = null;  # onDrag(bool dragStart)
#var onDragCancel = null; # onDragCancel

func init(shape:ShapeObject, count = -1):
	self.shape = shape;
	self.count = count;
	ShapeUtils.recreateShape(self)

func _ready():
	pass

func setDragState(draggable:bool, onDrag:Callable):
	self.draggable = draggable
	self.onDrag = onDrag


func _process(delta):
	if dragging:
		# TODO 
		self.position = get_viewport().get_mouse_position() + Vector2(Global.UNIT_SIZE, Global.UNIT_SIZE) / 2;
		

func _on_gui_input(ev):
	print("click")
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		print("click")
		if ev.pressed:
			if draggable and !dragging:
				dragging = true
				if onDrag: onDrag.call(true)
		else:
			if dragging:
				dragging = true
				if onDrag: onDrag.call(false)

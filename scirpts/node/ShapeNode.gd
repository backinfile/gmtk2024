class_name ShapeNode
extends Control

var shape:ShapeObject;
var count = -1;
var optionIndex = -1;


# scaleMode 0- workSpace use Global.UNIT_SIZE 
# scaleMode 1- goal use Global.UNIT_SIZE_2 
# scaleMode 2- optionBtn fixed 50
var scaleMode:int = 0  


var dragging = false;
var draggable = false;
var onDrag = null;  # onDrag(bool dragStart)
var onDragUpdate = null;
#var onDragCancel = null; # onDragCancel

var renderOnWorkspace = false;

@export var triangle_color:Color = Color.BLACK:
	set(value):
		if shapes:
			for s in shapes.get_children():
				s.color = value
		triangle_color = value

@onready var shapes = get_node("shapes")

@export var workspaceMaterial:Material;
@export var materialColorA:Color;
@export var materialColorB:Color;

var borderVisible:bool:
	get: 
		return $border.visible
	set(value): 
		$border.visible = value
		print("set border ", value)

func init(shape:ShapeObject, count = -1, scaleMode = 0):
	self.shape = shape;
	self.count = count;
	self.scaleMode = scaleMode;
	recreateShape()

func updatePosition():
	self.position = shape.position * Global.UNIT_SIZE

func makeCopy():
	var node = Global.createShapeNode(shape.makeCopy())
	node.optionIndex = optionIndex
	return node


func recreateShape():
	#ShapeUtils.recreateShape(self)
	var control:Control = get_node("shapes")
	custom_minimum_size = shape.curShape.shapeSize() * getUnitSize()
	control.custom_minimum_size = shape.curShape.shapeSize() * getUnitSize()
	#print("recreateShape ", custom_minimum_size)
	Global.clear_children(control)
	for s in shape.curShape.area:
		var p = getPolygonByDur(s[2])
		#print("add Polygon ", p.polygon)
		p.color = triangle_color
		p.position = Vector2(s[0] * getUnitSize(), s[1] * getUnitSize())
		control.add_child(p)
		
	var border:Control = get_node("border")
	Global.clear_children(border)
	#var size = custom_minimum_size
	#var line = preload("res://nodes/dotline.tscn").instantiate()
	#line.default_color = Color.BLUE
	#line.width = 20
	#line.clear_points()
	#line.add_point(Vector2(0,0))
	#line.add_point(Vector2(size.x,0))
	#line.add_point(Vector2(size.x,size.y))
	#line.add_point(Vector2(0,size.y))
	#line.add_point(Vector2(0,0))
	#border.add_child(line)
	var size = getUnitSize()
	var outlines = shape.curShape.get_outline()
	for outline in outlines: 
		var line := Line2D.new() as Line2D
		line.clear_points()
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		line.width = 5
		line.default_color = Color.BLACK
		line.closed = true
		for p in outline:
			line.add_point(p * size)
		border.add_child(line)
	

func getUnitSize():
	if scaleMode == 0:
		return Global.UNIT_SIZE
	elif scaleMode == 1:
		return Global.UNIT_SIZE_2
	return 40 / shape.curShape.shapeSize().x

func getPolygonByDur(dur:int):
	var p = Polygon2D.new()
	if scaleMode == 0 || scaleMode == 1:
		p.material = workspaceMaterial.duplicate()
	var size = getUnitSize();
	var mid = getUnitSize() / 2;
	var polygon = []
	polygon.append(Vector2(mid, mid))
	match dur:
		Shape.DUR.UP: 
			polygon.append(Vector2(0, 0))
			polygon.append(Vector2(size, 0))
		Shape.DUR.LEFT: 
			polygon.append(Vector2(0, 0))
			polygon.append(Vector2(0, size))
		Shape.DUR.DOWN: 
			polygon.append(Vector2(size, size))
			polygon.append(Vector2(0, size))
		Shape.DUR.RIGHT: 
			polygon.append(Vector2(size, size))
			polygon.append(Vector2(size, 0))
	p.polygon = polygon
	return p

func _ready():
	setDragState(false)
	pass

func setDragState(draggable:bool, onDrag:Callable = func (d):pass, onDragUpdate:Callable = func ():pass):
	self.draggable = draggable
	self.onDrag = onDrag
	self.onDragUpdate = onDragUpdate

func _process(delta):
	if dragging:
		self.global_position = get_viewport().get_mouse_position() - shape.curShape.shapeSize() / 2 * Global.UNIT_SIZE;
		

func _on_gui_input(ev):
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed:
			if draggable and !dragging:
				dragging = true
				if onDrag: onDrag.call(true)
		else:
			if dragging:
				if onDrag: onDrag.call(false)
				dragging = false
	elif ev is InputEventMouseMotion:
		if dragging:
			if onDragUpdate: onDragUpdate.call();

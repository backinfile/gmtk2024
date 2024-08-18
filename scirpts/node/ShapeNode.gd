class_name ShapeNode
extends Control

var shape:ShapeObject;
var count = -1;

var dragging = false;
var draggable = false;
var onDrag = null;  # onDrag(bool dragStart)
var onDragUpdate = null;
#var onDragCancel = null; # onDragCancel


func init(shape:ShapeObject, count = -1):
	self.shape = shape;
	self.count = count;
	recreateShape()

func updatePosition():
	self.position = shape.position * Global.UNIT_SIZE

func makeCopy():
	return Global.createShapeNode(shape.makeCopy())

func recreateShape():
	ShapeUtils.recreateShape(self)
	custom_minimum_size = shape.curShape.shapeSize() * Global.UNIT_SIZE
	print("recreateShape ", custom_minimum_size)
	for p in get_children():
		if p is not ColorRect:
			remove_child(p)
			p.queue_free()
	for s in shape.curShape.area:
		var p = getPolygonByDur(s[2])
		#print("add Polygon ", p.polygon)
		p.position = Vector2(s[0] * Global.UNIT_SIZE, s[1] * Global.UNIT_SIZE)
		add_child(p)

func getPolygonByDur(dur:int):
	var p = Polygon2D.new()
	var size = Global.UNIT_SIZE;
	var mid = Global.UNIT_SIZE / 2;
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

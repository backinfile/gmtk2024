class_name ShapeObject
extends RefCounted

var oriShape: Shape;
var curShape: Shape;
var scale = 1;
var position: Vector2i = Vector2i.ZERO;

func _init(shape: Shape):
	oriShape = shape.duplicate()
	curShape = shape.duplicate()
	
func makeCopy():
	var s = ShapeObject.new(oriShape)
	#s.oriShape = oriShape.duplicate()
	s.curShape = curShape.duplicate()
	s.scale = scale
	s.position = position
	return s

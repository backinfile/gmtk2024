class_name ShapeObject
extends Node

var oriShape: Shape;
var curShape: Shape;
var scale = 1;
var position: Vector2i = Vector2i.ZERO;

func _init(shape: Shape):
	oriShape = shape.duplicate()
	curShape = shape.duplicate()
	

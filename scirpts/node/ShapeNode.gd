class_name ShapeNode
extends Control

var shape:ShapeObject;
var count = -1;

func init(shape:ShapeObject, count = -1):
	self.shape = shape;
	self.count = count;
	ShapeUtils.recreateShape(self)

func _ready():
	pass

func _process(delta):
	pass

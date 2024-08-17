extends Node

var UNIT_SIZE = 50;



@onready var shape_node_tscn:PackedScene = load("res://shape_node.tscn");

func createShapeNode(shape:ShapeObject, count = 1):
	var node:ShapeNode = shape_node_tscn.instantiate()
	node.init(shape, count);
	return node;
	

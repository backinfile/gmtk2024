class_name GameMap
extends Node

var map: Array[ShapeNode] = [];
var width = 5;
var height = 5;

func _init():
	pass
	
func mapSize():
	return Vector2(width, height)

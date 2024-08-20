class_name Level
extends Resource

@export var id: int = 1;
@export var shapes: Array[Shape]
@export var shapesCount:Array[int] = []
@export var goal:Shape;
@export var width = 5;
@export var height = 5;
@export var canRotate = true
@export var tutorial:Array[PackedScene];

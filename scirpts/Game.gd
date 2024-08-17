class_name Game
extends Control


#var shapesInSelectPancel:Array[ShapeNode] = []
#var shapesInOptionPancel:Array[ShapeNode] = []
#var shapesInWorkSpace:Array[ShapeNode] = []

@export var curLevel:Level;
var gameMap:GameMap;
var curSelectedShape:ShapeObject;

@onready var workSpace = $WorkSpace
@onready var selectPancel = $SelectPanel/VBoxContainer

static var Instance:Game = self;

func _ready():
	gameMap = GameMap.new();
	for index in range(curLevel.shapes.size()):
		var shape = curLevel.shapes[index]
		var count = curLevel.shapesCount[index]
		var shapeObject = ShapeObject.new(shape)
		selectPancel.add_child(Global.createShapeNode(shapeObject, count))

func _process(delta):
	
	var dx = 0
	var dy = 0
	if Input.is_action_just_pressed("DOWN"):
		dy -= 1
	elif Input.is_action_just_pressed("LEFT"):
		dx -= 1
	elif Input.is_action_just_pressed("RIGHT"):
		dx += 1
	elif Input.is_action_just_pressed("UP"):
		dy += 1
	if dx != 0 or dy != 0:
		ControlManager.move(dx, dy)
	
	if Input.is_action_just_pressed("SCALE_UP"):
		ControlManager.sacle(true)
	elif Input.is_action_just_pressed("SCALE_DOWN"):
		ControlManager.sacle(false)
	pass
	

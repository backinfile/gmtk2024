class_name Game
extends Control


#var shapesInSelectPancel:Array[ShapeNode] = []
#var shapesInOptionPancel:Array[ShapeNode] = []
#var shapesInWorkSpace:Array[ShapeNode] = []

@export var curLevel:Level;
var gameMap:GameMap;
var curSelectedShape:ShapeNode;
var curOperationShape:ShapeNode;

@onready var workSpace:Control = $WorkSpace
@onready var optionPanel = $OptionPanel

static var Instance:Game;

func _init():
	Instance = self

func _ready():
	gameMap = GameMap.new();
	gameMap.width = curLevel.width
	gameMap.height = curLevel.height
	
	if true:
		var size = workSpace.get_node("Box").size
		Global.UNIT_SIZE = size.x / gameMap.width
	if true:
		var size = $Goal/Box.size
		Global.UNIT_SIZE_2 = size.x / gameMap.width
		
	
	OptionRenderManager.refresh()
	WorkspaceRenderManager.refresh()
	GoalRenderManger.refresh()

func _process(delta):
	pass
	
	var dx = 0
	var dy = 0
	if Input.is_action_just_pressed("DOWN"):
		dy += 1
	elif Input.is_action_just_pressed("LEFT"):
		dx -= 1
	elif Input.is_action_just_pressed("RIGHT"):
		dx += 1
	elif Input.is_action_just_pressed("UP"):
		dy -= 1
	if dx != 0 or dy != 0:
		ControlManager.move(dx, dy)
	
	if curOperationShape != null:
		ControlManager.onDrawing()
		
	if Input.is_action_just_pressed("save"):
		saveToFile()
	if Input.is_action_just_pressed("saveFile"):
		saveToLevelFile()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		ControlManager.onDrawStart(event.is_pressed())
	#elif event is InputEventMouseMotion:
		#ControlManager.onDrawing()

	
func _on_undo_btn_pressed():
	ControlManager.undo()

func saveToFile():
	var shape = WorkspaceRenderManager.workspaceToShape(false);
	ResourceSaver.save(shape, "res://resources/shape_saved.tres")
	print("saved!!")

func saveToLevelFile():
	var level = Level.new()
	level.goal = WorkspaceRenderManager.workspaceToShape(false);
	level.width = curLevel.width
	level.height = curLevel.height
	
	var map = {}
	for node in gameMap.map:
		if node.optionIndex in map:
			map[node.optionIndex] += 1
		else:
			map[node.optionIndex] = 1
	for index in map.keys():
		var node = OptionRenderManager.optionShapeList[index]
		level.shapes.append(node.shape.oriShape.duplicate())
		level.shapesCount.append(map[index])
		
	ResourceSaver.save(level, "res://resources/level_saved.tres")
	print("level saved!!")

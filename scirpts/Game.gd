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
	gameMap.width = 5
	gameMap.height = 5
	
	var size = workSpace.get_node("Box").size
	Global.UNIT_SIZE = size.x / gameMap.width
	
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

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		ControlManager.onDrawStart(event.is_pressed())
	#elif event is InputEventMouseMotion:
		#ControlManager.onDrawing()

	
func _on_undo_btn_pressed():
	ControlManager.undo()

func saveToFile():
	var shape = WorkspaceRenderManager.workspaceToShape();
	ResourceSaver.save(shape, "res://resources/shape_saved.tres")

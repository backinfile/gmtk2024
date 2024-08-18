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
@onready var selectPancel = $SelectPanel

static var Instance:Game;

func _init():
	Instance = self

func _ready():
	gameMap = GameMap.new();
	for index in range(curLevel.shapes.size()):
		var shape = curLevel.shapes[index]
		var count = curLevel.shapesCount[index]
		var shapeObject = ShapeObject.new(shape)
		var node = Global.createShapeNode(shapeObject, count)
		print(node.shape.curShape.area)
		curSelectedShape = node
		selectPancel.add_child(node)
	#ControlManager.scale(true)
	#ControlManager.scale(true)
	#ControlManager.scale(true)
	
	WorkspaceRenderManager.refresh()

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

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		ControlManager.onDrawStart(event.is_pressed())
	#elif event is InputEventMouseMotion:
		#ControlManager.onDrawing()


	

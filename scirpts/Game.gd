class_name Game
extends Control


#var shapesInSelectPancel:Array[ShapeNode] = []
#var shapesInOptionPancel:Array[ShapeNode] = []
#var shapesInWorkSpace:Array[ShapeNode] = []

@export var curLevel:Level;

var gameMap:GameMap;
var curSelectedShape:ShapeNode;
var curOperationShape:ShapeNode:
	set(value):
		if curOperationShape: curOperationShape.borderVisible = false
		if value: value.borderVisible = true
		curOperationShape = value
	
var debugMode = false
var canRotateShape = true

@onready var workSpace:Control = $WorkSpace
@onready var optionPanel = $OptionPanel
@onready var workSpaceRotateAnchor:Control = $WorkSpace/Anchor
@onready var workSpaceDotline:Node2D = $WorkSpace/Box/Dotline
@onready var workSpaceHoverDotlines:Control = $WorkSpace/Box/HoverDotlines
@onready var goalText = $Goal/Label
static var Instance:Game;

func _init():
	Instance = self

func _ready():
	if get_tree().current_scene.name == "Game":
		$ReturnBtn.disabled = true
		if curLevel != null:
			setLevel(curLevel)
		debugMode = true
		

func setLevel(level:Level, levelNumber:int = -1):
	curLevel = null
	if true:
		Global.clear_children($Tutorial)
		if level.tutorial:
			for t in level.tutorial:
				$Tutorial.add_child(t.instantiate())
	
	$AnimationPlayer.play("enter")
	curLevel = level
	curOperationShape = null
	curSelectedShape = null
	gameMap = GameMap.new();
	gameMap.width = curLevel.width
	gameMap.height = curLevel.height
	canRotateShape = curLevel.canRotate
	if true:
		var size = workSpace.get_node("Box").size
		Global.UNIT_SIZE = size.x / gameMap.width
	if true:
		var size = $Goal/Box.size
		Global.UNIT_SIZE_2 = size.x / gameMap.width
	OptionRenderManager.refresh()
	WorkspaceRenderManager.refresh()
	GoalRenderManger.refresh()
	if levelNumber > 0:
		goalText.text = "Goal " + str(levelNumber)
	else:
		goalText.text = "Goal"
	

func _process(delta):
	if curLevel == null: return
	if $Tutorial.get_child_count() > 0: return
	
	ControlManager.onDrawing()
	
	if debugMode:
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
		
		if Input.is_action_just_pressed("save"):
			saveToFile()
		if Input.is_action_just_pressed("saveFile"):
			saveToLevelFile()

func _input(event):
	if curLevel == null: return
	if $Tutorial.get_child_count() > 0: return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		ControlManager.onDrawStart(event.is_pressed())
	elif event.is_action("Move"):
		ControlManager.onStartDrawWithMove(event.is_pressed())
	#elif event is InputEventMouseMotion:
		#ControlManager.onDrawing()

	
func _on_undo_btn_pressed():
	Global.playSoundEffect("undo")
	ControlManager.undo()
	
func _on_restart_btn_pressed():
	Global.playSoundEffect("undo")
	var cnt = gameMap.map.size()
	for i in range(cnt):
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


func _on_return_btn_pressed():
	Main.Instance.changeToSelectLevelScene()

func enter_level():
	pass

func exit_level():
	pass

func win():
	clearScene()
	Main.Instance.saveCurLevel()
	Main.Instance.refreshLevelBtn()
	Global.playSoundEffect("success")
	$AnimationPlayer.play("exit")
	await $AnimationPlayer.animation_finished
	Main.Instance.changeToNextLevel()
	
func clearScene():
	curLevel = null
	curSelectedShape = null
	curOperationShape = null

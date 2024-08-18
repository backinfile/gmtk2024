class_name Main
extends Control

static var Instance:Main;
var curLevelIndex = -1
var levelPaths = []

func _init():
	Instance = self

# Called when the node enters the scene tree for the first time.
func _ready():
	changeToTitleScene(true)
	loadLevelBtns()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeToTitleScene(fromGameStart = false):
	$Levels.visible = false
	$Game.visible = false
	$Title.visible = true
	
func changeToSelectLevelScene():
	$Game.visible = false
	$Title.visible = false
	$Levels.visible = true

func changeToGameScene(levelIndex:int):
	$Title.visible = false
	$Levels.visible = false
	curLevelIndex = levelIndex
	var levelPath = levelPaths[curLevelIndex]
	print("changeToGameScene levelPath ", levelPath)
	
	var level = ResourceLoader.load(levelPath)
	$Game.setLevel(level)
	$Game.visible = true

func changeToNextLevel():
	if curLevelIndex + 1 < levelPaths.size():
		changeToGameScene(curLevelIndex + 1)
	else:
		changeToTitleScene()

func _on_start_game_btn_pressed():
	changeToSelectLevelScene()

func loadLevelBtns():
	var dir = DirAccess.open("res://resources/internalLevels/")
	if dir:
		var levelFilePaths = Array(dir.get_files())
		var container = $Levels/GridContainer
		for i in range(levelFilePaths.size()):
			var fileName = levelFilePaths[i]
			var path = "res://resources/internalLevels/" + fileName
			levelPaths.append(path)
			var levelEntry = preload("res://nodes/level_entry_btn.tscn").instantiate()
			levelEntry.levelPath = path
			levelEntry.index = i;
			container.add_child(levelEntry)

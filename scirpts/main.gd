class_name Main
extends Control

static var Instance:Main;
var nextLevelFilePath = null

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

func changeToGameScene(levelPath:String):
	$Title.visible = false
	$Levels.visible = false
	$Game.visible = true
	var level = ResourceLoader.load(levelPath)
	$Game.setLevel(level)

func changeToNextLevel():
	if nextLevelFilePath:
		changeToGameScene(nextLevelFilePath)
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
			var nextFilePath = levelFilePaths[i + 1] if i + 1 < levelFilePaths.size() else null
			var path = "res://resources/internalLevels/" + fileName
			var levelEntry = preload("res://nodes/level_entry_btn.tscn").instantiate()
			levelEntry.levelPath = path
			levelEntry.nextLevelPath = nextFilePath
			levelEntry.index = i;
			container.add_child(levelEntry)

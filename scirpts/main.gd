class_name Main
extends Control

static var Instance:Main;
var curLevelIndex = -1
var levelPaths = []
var levelBtns = []
var curScene: Control

var savedIndex = -1;

func _init():
	Instance = self

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	#changeToTitleScene(true)
	
	$Levels.position = Vector2(0, size.y)
	$Levels.show()
	$Game.position = Vector2(0, size.y)
	$Game.show()
	$Title.position = Vector2(0, 0)
	$Title.show()
	curScene = $Title
	loadLevelBtns()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeScene(scene: Control):
	const DURATION = .5
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(curScene, "position:y", -size.y, DURATION)
	scene.position.y = size.y
	tween.parallel().tween_property(scene, "position:y", 0, DURATION)
	curScene = scene

func changeToTitleScene(fromGameStart = false):
	changeScene($Title)
	
func changeToSelectLevelScene():
	refreshLevelBtn()
	changeScene($Levels)

func changeToGameScene(levelIndex:int, anim: bool = true):
	curLevelIndex = levelIndex
	var levelPath = levelPaths[curLevelIndex]
	print("changeToGameScene levelPath ", levelPath)
	
	var level = ResourceLoader.load(levelPath)
	$Game.setLevel(level)
	if anim: changeScene($Game)

func changeToNextLevel():
	savedIndex = max(savedIndex, curLevelIndex)
	save_game()
	if curLevelIndex + 1 < levelPaths.size():
		changeToGameScene(curLevelIndex + 1, false)
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
			levelBtns.append(levelEntry)

func refreshLevelBtn():
	for i in range(levelBtns.size()):
		levelBtns[i].disabled = i > savedIndex + 1

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify({"savedIndex": savedIndex})
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var node_data  = JSON.parse_string(json_string)
	if not node_data:
			print("JSON Parse Error: ", json_string)
			return
	savedIndex = node_data["savedIndex"]

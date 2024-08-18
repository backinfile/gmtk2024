extends Button

var levelPath:String;
var nextLevelPath;
var index:int;

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	Main.Instance.nextLevelFilePath = nextLevelPath
	Main.Instance.changeToGameScene(levelPath)

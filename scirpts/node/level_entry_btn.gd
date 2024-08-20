extends TransitionButton

var levelPath:String;
var nextLevelPath;
var index:int;
var complete = false:
	set(value):
		complete = value
		if complete: add_theme_color_override("font_color", Color("71C6C8"))

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(index + 1)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	Main.Instance.changeToGameScene(index)

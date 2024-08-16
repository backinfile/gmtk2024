extends Node2D

func _process(delta):
	$ColorRect.rotation_degrees += 10 * delta;
	Utils.test()
	print(Utils.SIZE)
	Global.SIZE = 1;
	Global.test()
	pass

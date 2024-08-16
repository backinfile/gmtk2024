extends Node2D

func _process(delta):
	$ColorRect.rotation_degrees += 10 * delta;
	Global.SIZE = 1;
	Global.test()
	pass
  # Quanthon Edit

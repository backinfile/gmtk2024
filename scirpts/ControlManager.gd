class_name ControlManager
extends Node

static func move(dx:int, dy:int):
	var shape = Game.Instance.curSelectedShape;
	if shape == null: return;
	var size = shape.curShape.shapeSize()
	var map = Game.Instance.gameMap;
	
	var x = shape.position.x + dx
	var y = shape.position.y + dy
	
	# TODO check edge
	
	shape.position = Vector2i(x, y)
	
	# TODO update image


static func scale(up:bool):
	var shapeNode = Game.Instance.curSelectedShape;
	if shapeNode == null: return;
	var shape = shapeNode.shape
	var size = shape.curShape.shapeSize()
	var map = Game.Instance.gameMap;
	var scale = shape.scale + (1 if up else -1)
	if scale < 1: return
	var result = shape.oriShape.scaleUp(scale)
	
	# TODO check
	
	shape.curShape = result
	shape.scale = scale
	shapeNode.recreateShape()
	
	# TODO Update texture









	

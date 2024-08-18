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

static var drawing = false

static func onDrawStart(start):
	if Game.Instance.curSelectedShape == null: return
	if start:
		var mouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
		print("onDrawStart mouse = ", mouse)
		if mouse.x >= 0 || mouse.y >= 0:
			drawing = true;
			Game.Instance.curOperationShape = Game.Instance.curSelectedShape.makeCopy()
			Game.Instance.curOperationShape.shape.position = mouse
			Game.Instance.curOperationShape.updatePosition()
			WorkspaceRenderManager.addNodeToWorkspace(Game.Instance.curOperationShape)
		return
	
	drawing = false
	Game.Instance.curOperationShape = null

static func onDrawing():
	if !drawing or Game.Instance.curOperationShape == null: return
	





	

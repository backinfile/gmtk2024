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
	
	var shapeNode = Game.Instance.curOperationShape
	var scale = 1
	var position = shapeNode.shape.position 
	
	var shapeSize = shapeNode.shape.oriShape.shapeSizeI()
	var mouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
	var offset = Global.div(mouse - shapeNode.shape.position, shapeSize)
	print("onDrawing offset = ", offset)
	if offset.x > 0 && offset.y > 0:
		scale = max(offset.x, offset.y)
	else:
		return
	
	if scale != shapeNode.shape.scale:
		var scaled = shapeNode.shape.oriShape.scaleUp(scale)
		shapeNode.shape.curShape = scaled
		shapeNode.shape.scale = scale
		shapeNode.recreateShape()
	if position != shapeNode.shape.position:
		shapeNode.shape.position = position
		shapeNode.updatePosition()
	
	
	





	

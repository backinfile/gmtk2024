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
static var drawingPosition:Vector2i = Vector2i.ZERO;

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
			drawingPosition = mouse
		return
	else:
		drawing = false
		Game.Instance.curOperationShape = null
		drawingPosition = Vector2i.ZERO

static func onDrawing():
	if !drawing or Game.Instance.curOperationShape == null: return
	
	var shapeNode = Game.Instance.curOperationShape
	var scale = 1
	var position = drawingPosition 
	
	var shapeSize = shapeNode.shape.oriShape.shapeSizeI()
	var mouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
	var offset = mouse - position
	var offsetBySize = Global.div(mouse - position, shapeSize)
	print("onDrawing offset = ", offset, " offsetBySize = ", offsetBySize)
	if offset.x >= 0 and offset.y >= 0 and offset.x < shapeSize.x and offset.y < shapeSize.y:
		scale = 1
	elif offsetBySize.x >= 0 && offsetBySize.y >= 0:
		scale = max(offset.x, offset.y) + 1
	elif offsetBySize.x >= 0 && offsetBySize.y < 0:
		scale = max(offset.x, absi(offset.y)) + 1
		position = Vector2i(position.x, position.y - (scale - 1) * shapeSize.y)
	elif offsetBySize.x < 0 && offsetBySize.y < 0:
		scale = max(absi(offset.x), absi(offset.y)) + 1
		position = Vector2i(position.x - (scale - 1) * shapeSize.x, position.y - (scale - 1) * shapeSize.y)
	elif offsetBySize.x < 0 && offsetBySize.y >= 0:
		scale = max(absi(offset.x), absi(offset.y)) + 1
		position = Vector2i(position.x - (scale - 1) * shapeSize.x, position.y)
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
	
	
	





	

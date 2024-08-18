class_name ControlManager
extends Node

static func move(dx:int, dy:int):
	var shapeNode = Game.Instance.curOperationShape;
	if shapeNode == null: return;
	var size = shapeNode.shape.curShape.shapeSize()
	var map = Game.Instance.gameMap;
	
	var x = shapeNode.shape.position.x + dx
	var y = shapeNode.shape.position.y + dy
	
	# TODO check edge
	
	shapeNode.shape.position = Vector2i(x, y)
	shapeNode.updatePosition()
	
	# TODO update image
	WorkspaceRenderManager.refreshShapeBoolean()

static var drawing = false
static var drawingPosition:Vector2i = Vector2i.ZERO;

static func onDrawStart(start):
	var shapeNode = Game.Instance.curSelectedShape
	if shapeNode == null: return
	if start:
		var mouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
		if mouse.x >= 0 && mouse.y >= 0 && mouse.x < Game.Instance.gameMap.width && mouse.y < Game.Instance.gameMap.height:
			print("onDrawStart mouse = ", mouse)
			drawing = true;
			Game.Instance.curOperationShape = Game.Instance.curSelectedShape.makeCopy()
			Game.Instance.curOperationShape.shape.position = mouse
			Game.Instance.curOperationShape.updatePosition()
			WorkspaceRenderManager.addNodeToWorkspace(Game.Instance.curOperationShape)
			drawingPosition = mouse
			WorkspaceRenderManager.refreshShapeBoolean()
		return
	
	if drawing:
		drawing = false
		drawingPosition = Vector2i.ZERO
		OptionRenderManager.modifyCurSelectCount(Game.Instance.curSelectedShape, -1)

static func onDrawing():
	if !drawing: return
	if Game.Instance.curOperationShape == null: return
	
	var shapeNode = Game.Instance.curOperationShape
	var scale = 1
	var position = drawingPosition 
	
	var shapeSize = shapeNode.shape.oriShape.shapeSizeI()
	var mouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
	var offset = mouse - position
	var offsetBySize = Global.div(mouse - position, shapeSize)
	#print("onDrawing offset = ", offset, " offsetBySize = ", offsetBySize)
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
		
	var changed = scale != shapeNode.shape.scale or position != shapeNode.shape.position
	
	if scale != shapeNode.shape.scale:
		var scaled = shapeNode.shape.oriShape.scaleUp(scale)
		shapeNode.shape.curShape = scaled
		shapeNode.shape.scale = scale
		shapeNode.recreateShape()
	if position != shapeNode.shape.position:
		shapeNode.shape.position = position
		shapeNode.updatePosition()
	if changed:
		WorkspaceRenderManager.refreshShapeBoolean()
	
	
static func undo():
	Game.Instance.curOperationShape = null
	var map = Game.Instance.gameMap.map
	if map:
		var node = map[map.size() - 1]
		WorkspaceRenderManager.removeNodeFromWorkspace(node)
		OptionRenderManager.modifyCurSelectCount(node, 1)
	WorkspaceRenderManager.refreshShapeBoolean()
		
		




	

class_name ControlManager
extends Node

static var cursor_expand = preload("res://assets/img/expand.svg")
static var cursor_expand_rotate = preload("res://assets/img/expand-rotate.svg")
static var cursor_move = preload("res://assets/img/move.svg")

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
static var drawingPosition:Vector2i = Vector2i(-1, -1):
	set(value):
		var anchor = Game.Instance.workSpaceRotateAnchor
		if value.x >= 0:
			anchor.visible = true
			anchor.global_position = WorkspaceRenderManager.getWorldPositionByWorkspacePosition(value) - anchor.size / 2
		else: anchor.visible = false
		drawingPosition = value

static func onDrawStart(start):
	var shapeNode = Game.Instance.curSelectedShape
	if shapeNode == null: return
	if start:
		var mouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
		if mouse.x >= 0 && mouse.y >= 0 && mouse.x < Game.Instance.gameMap.width && mouse.y < Game.Instance.gameMap.height:
			print("onDrawStart mouse = ", mouse)
			drawing = true;
			lastNegOffset = Vector2i.ZERO
			Game.Instance.curOperationShape = Game.Instance.curSelectedShape.makeCopy()
			Game.Instance.curOperationShape.shape.position = mouse
			Game.Instance.curOperationShape.updatePosition()
			WorkspaceRenderManager.addNodeToWorkspace(Game.Instance.curOperationShape)
			drawingPosition = mouse
			WorkspaceRenderManager.refreshShapeBoolean()
			if Game.Instance.canRotateShape:
				Input.set_custom_mouse_cursor(cursor_expand_rotate, 0, Vector2(11, 11))
			else:
				Input.set_custom_mouse_cursor(cursor_expand, 0, Vector2(11, 11))
		return
	
	if drawing:
		drawing = false
		drawingPosition = Vector2i(-1, -1)
		OptionRenderManager.modifyCurSelectCount(Game.Instance.curSelectedShape, -1)
		if Game.Instance.curOperationShape:
			Game.Instance.curOperationShape.borderVisible = false
		Input.set_custom_mouse_cursor(null)
		
		if GoalRenderManger.isWin():
			print("check win = true");
			if !Game.Instance.debugMode:
				#Main.Instance.changeToNextLevel()
				Game.Instance.win()
		Game.Instance.workSpaceDotline.visible = false



static var dragMode = false
static var dragStartMouse:Vector2i = Vector2i.ZERO
static var lastNegOffset:Vector2i = Vector2i.ZERO
static func onStartDrawWithMove(start:bool):
	dragMode = start
	if start:
		dragStartMouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
		Input.set_custom_mouse_cursor(cursor_move, 0, Vector2(11, 11))
	else:
		if drawing:
			Input.set_custom_mouse_cursor(cursor_expand_rotate, 0, Vector2(11, 11))
		else:
			Input.set_custom_mouse_cursor(cursor_expand, 0, Vector2(11, 11))
			

static func onDrawing():
	if true: # draw hover dotlion
		var hoverDotlines = Game.Instance.workSpaceHoverDotlines
		if drawing:
			hoverDotlines.visible = false
		elif Game.Instance.curSelectedShape:
			var p = WorkspaceRenderManager.getMousePositionOnWorkspace()
			var anchor = Game.Instance.workSpaceRotateAnchor
			if Game.Instance.gameMap and Game.Instance.gameMap.contains(p):
				hoverDotlines.global_position = WorkspaceRenderManager.getWorldPositionByWorkspacePosition(p)
				hoverDotlines.visible = true
				anchor.visible = true
				anchor.global_position = WorkspaceRenderManager.getWorldPositionByWorkspacePosition(p) - anchor.size / 2
			else:
				hoverDotlines.visible = false
				anchor.visible = false
	
	if !drawing: return
	if Game.Instance.curOperationShape == null: return
	
	var shapeNode = Game.Instance.curOperationShape
	var curLevel = Game.Instance.curLevel
	var gameMapSize = Vector2i(Game.Instance.gameMap.width, Game.Instance.gameMap.height)
	var scale = 1
	var position = drawingPosition
	var shapeSize = shapeNode.shape.oriShape.shapeSizeI()
	var mouse = WorkspaceRenderManager.getMousePositionOnWorkspace()
	
	# check right click to move
	if dragMode:
		var diff = mouse - dragStartMouse
		drawingPosition = drawingPosition + diff
		dragStartMouse = mouse
		if diff.x != 0 or diff.y != 0:
			shapeNode.shape.position = drawingPosition - lastNegOffset
			shapeNode.updatePosition()
			WorkspaceRenderManager.refreshShapeBoolean()
			Game.Instance.workSpaceDotline.visible = false
		return
	
	# check angle
	var angle = WorkspaceRenderManager.getMouseAngleOnWorkspace(position)
	# check scale
	var offset = mouse - position
	offset = Vector2i(offset.x + 1, offset.y) if offset.x < 0 else offset
	offset = Vector2i(offset.x, offset.y + 1) if offset.y < 0 else offset
	var offsetBySize = Global.div(offset, shapeSize)
	var scalePositionOffset = Vector2i.ZERO
	var angelPositionOffsetFactor = Vector2i(1, 1)
	#print("onDrawing offset = ", offset, " offsetBySize = ", offsetBySize)
	if offset.x >= 0 and offset.y >= 0 and offset.x < shapeSize.x and offset.y < shapeSize.y:
		scale = 1
	elif offsetBySize.x >= 0 && offsetBySize.y >= 0:
		scale = max(offsetBySize.x, offsetBySize.y) + 1
	elif offsetBySize.x >= 0 && offsetBySize.y < 0:
		scale = max(offsetBySize.x, absi(offsetBySize.y)) + 1
		scalePositionOffset = Vector2i(0,  - (scale - 1) * shapeSize.y)
	elif offsetBySize.x < 0 && offsetBySize.y < 0:
		scale = max(absi(offsetBySize.x), absi(offsetBySize.y)) + 1
		scalePositionOffset = Vector2i( - (scale - 1) * shapeSize.x,  - (scale - 1) * shapeSize.y)
	elif offsetBySize.x < 0 && offsetBySize.y >= 0:
		scale = max(absi(offsetBySize.x), absi(offsetBySize.y)) + 1
		scalePositionOffset = Vector2i(- (scale - 1) * shapeSize.x, 0)
	else:
		print("errrr")
	
	if not Game.Instance.canRotateShape:
		angle = 0
		if not (offsetBySize.x >= 0 && offsetBySize.y >= 0):
			return
	
	if abs(angle) == 45 or abs(angle) == 135: scale = max(1, scale - 1)
	if angle != shapeNode.shape.angle || scale != shapeNode.shape.scale:
		#print("angle = ", angle, " scale = ", scale)
		# do scale
		var scaledShape = shapeNode.shape.oriShape.scaleUp(scale)
		
		# do rotate
		var rotatedShape = scaledShape.rotate(angle)
		var negOffset = rotatedShape.getNegOffset()
		lastNegOffset = negOffset
		rotatedShape = rotatedShape.moveOffset(negOffset)
		#print("change angle = ", angle)
		#print("negOffset = ", negOffset, " old position = ", position)
		
		
		position = position - negOffset
		#position = position + scalePositionOffset
		
		# apply
		shapeNode.shape.curShape = rotatedShape
		shapeNode.shape.angle = angle
		shapeNode.shape.scale = scale
		shapeNode.recreateShape()
		shapeNode.shape.position = position
		shapeNode.updatePosition()
		WorkspaceRenderManager.refreshShapeBoolean()
		refreshDotline(angle, scale)

static func refreshDotline(angle, scale):
	if true:
		var factor = 2 if abs(angle) == 45 or abs(angle) == 135 else sqrt(2)
		var startPos = drawingPosition * Global.UNIT_SIZE
		var len = Vector2(0, scale * Global.UNIT_SIZE * factor)
		var endPos =  len.rotated(deg_to_rad(angle - Global.workspace_rotate_angle_offset))
		var dotline = Game.Instance.workSpaceDotline
		dotline.visible = true
		dotline.clear_points()
		dotline.add_point(startPos)
		dotline.add_point(startPos + endPos)
	
static func undo():
	Game.Instance.curOperationShape = null
	var map = Game.Instance.gameMap.map
	if map:
		var node = map[map.size() - 1]
		WorkspaceRenderManager.removeNodeFromWorkspace(node)
		OptionRenderManager.modifyCurSelectCount(node, 1)
	WorkspaceRenderManager.refreshShapeBoolean()
		
		

static func _get_max_scale_x_or_y(empty:Vector2i, shapeSize:Vector2i):
	var scale = min(empty.x / shapeSize.x, empty.y / shapeSize.y)
	#print("maxScale = ", scale)
	return scale
	


	

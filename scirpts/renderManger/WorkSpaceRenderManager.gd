class_name WorkspaceRenderManager
extends Node


static var shapeBoolCache = {}

static func getMousePositionOnWorkspace():
	var mouse = Game.Instance.get_viewport().get_mouse_position();
	var start = Game.Instance.workSpace.get_node("Box").global_position
	var offset = ((mouse - start) / Global.UNIT_SIZE)
	return Global.toVector2i(offset)

static func getPositionOnWorkspace(pos:Vector2):
	var start = Game.Instance.workSpace.get_node("Box").global_position
	var offset = ((pos - start) / Global.UNIT_SIZE)
	return Global.toVector2i(offset)

static var matchAngles = [0,  90, -90, 180, -180, 45, -45, 135, -135,]

static func getMouseAngleOnWorkspace(target:Vector2i):
	if getMousePositionOnWorkspace() == target:
		return 0
	var mouse = Game.Instance.get_viewport().get_mouse_position();
	var start = Game.Instance.workSpace.get_node("Box").global_position
	var targetPos = start + target * Global.UNIT_SIZE
	var angle = rad_to_deg(targetPos.angle_to_point(mouse))
	angle = (int(angle) + 180 + 360 - Global.workspace_rotate_angle_offset) % 360 - 180
	var minIndex = 0
	var minDis = 1000
	for i in range(matchAngles.size()):
		var dis = abs(angle - matchAngles[i])
		if dis < minDis:
			minDis = dis
			minIndex = i
	var finalAngle = matchAngles[minIndex]
	#print("angle = ", angle, " finalAngle = ", finalAngle)
	return finalAngle

static func getWorldPositionByWorkspacePosition(v:Vector2i):
	var start = Game.Instance.workSpace.get_node("Box").global_position
	return start + v * Global.UNIT_SIZE

static func addNodeToWorkspace(shape:ShapeNode):
	var Objs = Game.Instance.workSpace.get_node("Box").get_node("Objs");
	Objs.add_child(shape)
	shape.renderOnWorkspace = true
	var gameMap = Game.Instance.gameMap;
	gameMap.map.append(shape)

static func removeNodeFromWorkspace(shape:ShapeNode):
	var Objs = Game.Instance.workSpace.get_node("Box").get_node("Objs");
	Objs.remove_child(shape)
	var gameMap = Game.Instance.gameMap;
	gameMap.map.erase(shape)
	

static func refresh():
	shapeBoolCache.clear()
	var gameMap = Game.Instance.gameMap;
	#var Box = Game.Instance.workSpace.get_node("Box");
	#Box.size = Game.Instance.gameMap.mapSize() * Global.UNIT_SIZE + Vector2(Global.UNIT_EDGE, Global.UNIT_EDGE)
	
	var Objs = Game.Instance.workSpace.get_node("Box").get_node("Objs");
	Objs.size = Game.Instance.gameMap.mapSize() * Global.UNIT_SIZE + Vector2(Global.UNIT_EDGE, Global.UNIT_EDGE)
	Global.clear_children(Objs)
	
	# init grid
	var Grids = Game.Instance.workSpace.get_node("Box").get_node("Grids");
	Global.clear_children(Grids)
	for x in range(gameMap.width + 1):
		var line = preload("res://nodes/dotline.tscn").instantiate()
		line.default_color = Color.GRAY
		#line.width = Global.UNIT_EDGE
		line.clear_points()
		line.add_point(Vector2(x * Global.UNIT_SIZE + Global.UNIT_EDGE, 0 + Global.UNIT_EDGE))
		line.add_point(Vector2(x * Global.UNIT_SIZE + Global.UNIT_EDGE, gameMap.height * Global.UNIT_SIZE + Global.UNIT_EDGE))
		Grids.add_child(line)
	for y in range(gameMap.height + 1):
		var line = preload("res://nodes/dotline.tscn").instantiate()
		line.default_color = Color.GRAY
		#line.width = Global.UNIT_EDGE
		line.clear_points()
		line.add_point(Vector2(0 + Global.UNIT_EDGE, y * Global.UNIT_SIZE + Global.UNIT_EDGE))
		line.add_point(Vector2(gameMap.width * Global.UNIT_SIZE + Global.UNIT_EDGE, y * Global.UNIT_SIZE + Global.UNIT_EDGE))
		Grids.add_child(line)
	
	Game.Instance.workSpaceDotline.default_color = Global.workspace_dotline_color
	Game.Instance.workSpaceDotline.clear_points()
	Game.Instance.workSpaceDotline.width = Global.workspace_dotline_width
	
	
static func refreshShapeBoolean():
	var shapeRenderCache = {}
	for node in Game.Instance.gameMap.map:
		var p = node.shape.position
		for v in node.shape.curShape.area:
			v = Vector3i(v.x + p.x, v.y + p.y, v.z)
			if v in shapeRenderCache:
				shapeRenderCache[v] += 1
			else:
				shapeRenderCache[v] = 1
	for node in Game.Instance.gameMap.map:
		var p = node.shape.position
		var control = node.get_node("shapes")
		for i in range(node.shape.curShape.area.size()):
			var v = node.shape.curShape.area[i]
			v = Vector3i(v.x + p.x, v.y + p.y, v.z)
			var triangle:Polygon2D = control.get_child(i)
			var oldVisible = v in shapeBoolCache
			var newVisible = shapeRenderCache[v] % 2 == 1
			if oldVisible != newVisible:
				triangle.visible = true
				if newVisible: shapeBoolCache[v] = true
				else: shapeBoolCache.erase(v)
				var target = 1 if newVisible else 0
				#var targetColorA = Color(node.materialColorA, 1 if newVisible else 0)
				#var targetColorB = Color(node.materialColorB, 1 if newVisible else 0)
				var tween = node.create_tween()
				tween.tween_property(triangle, "color:a", target, .05)
				tween.tween_property(triangle, "color:a", target, .05)
			else:
				triangle.visible = newVisible
			#triangle.visible = shapeRenderCache[v] % 2 == 1
	#if GoalRenderManger.isWin():
		#print("win!!")
			
static func keyOfV(v:Vector3i, p:Vector2i) -> int:
	return (v[1] + p.y) * 100 + (v[0] + p.x) + v[2] * 10000

static func workspaceToShape(moveToLeftTop = true):
	var minX = -1
	var minY = -1
	var shapeRenderCache = {}
	var gameMap = Game.Instance.gameMap
	for node in Game.Instance.gameMap.map:
		var control = node.get_node("shapes")
		var p = node.shape.position
		for i in range(node.shape.curShape.area.size()):
			var v = node.shape.curShape.area[i]
			var pos = Vector3i(v[0] + p.x, v[1] + p.y, v[2])
			if pos not in WorkspaceRenderManager.shapeBoolCache: continue
			var triangle:Polygon2D = control.get_child(i)
			var x = v.x + p.x
			var y = v.y + p.y
			if x>=0 && x < gameMap.width && y>=0 && y < gameMap.height:
				v = Vector3i(x, y, v.z)
				shapeRenderCache[v] = true
				if minX < 0:
					minX = x
					minY = y
				else:
					minX = mini(x, minX)
					minY = mini(y, minY)
	if not moveToLeftTop:
		minX = 0
		minY = 0
	var shape = Shape.new()
	for v in shapeRenderCache.keys():
		var x = v.x - minX
		var y = v.y - minY
		shape.area.append(Vector3i(v.x - minX, v.y - minY, v.z))
	return shape


static func refreshHoverDotline():
	var HoverDotlines = Game.Instance.workSpaceHoverDotlines
	var shapeNode = Game.Instance.curSelectedShape
	if shapeNode == null:
		HoverDotlines.visible = false
		return
	Global.clear_children(HoverDotlines)
	var size = Global.UNIT_SIZE
	var outlines = shapeNode.shape.curShape.get_outline()
	for outline in outlines: 
		var line := Line2D.new() as Line2D
		line.clear_points()
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		line.width = 5
		line.default_color = Global.select_color
		line.closed = true
		for p in outline:
			line.add_point(p * size)
		HoverDotlines.add_child(line)

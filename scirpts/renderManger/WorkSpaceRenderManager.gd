class_name WorkspaceRenderManager
extends Node


static func getMousePositionOnWorkspace():
	var mouse = Game.Instance.get_viewport().get_mouse_position();
	var start = Game.Instance.workSpace.position
	var offset = ((mouse - start) / Global.UNIT_TOTAL)
	return Global.toVector2i(offset)

static func addNodeToWorkspace(shape:ShapeNode):
	var Objs = Game.Instance.workSpace.get_node("Mask").get_node("Objs");
	Objs.add_child(shape)
	var gameMap = Game.Instance.gameMap;
	gameMap.map.append(shape)

static func removeNodeFromWorkspace(shape:ShapeNode):
	var Objs = Game.Instance.workSpace.get_node("Mask").get_node("Objs");
	Objs.remove_child(shape)
	var gameMap = Game.Instance.gameMap;
	gameMap.map.erase(shape)
	

static func refresh():
	var gameMap = Game.Instance.gameMap;
	var Mask = Game.Instance.workSpace.get_node("Mask");
	Mask.size = Game.Instance.gameMap.mapSize() * Global.UNIT_SIZE + Vector2(Global.UNIT_EDGE, Global.UNIT_EDGE)
	
	var Objs = Game.Instance.workSpace.get_node("Mask").get_node("Objs");
	
	# init grid
	var Grids = Game.Instance.workSpace.get_node("Mask").get_node("Grids");
	Global.clear_children(Grids)
	for x in range(gameMap.width + 1):
		var line = Line2D.new()
		line.default_color = Color.GRAY
		line.width = Global.UNIT_EDGE
		line.add_point(Vector2(x * Global.UNIT_SIZE + Global.UNIT_EDGE, 0 + Global.UNIT_EDGE))
		line.add_point(Vector2(x * Global.UNIT_SIZE + Global.UNIT_EDGE, gameMap.height * Global.UNIT_SIZE + Global.UNIT_EDGE))
		Grids.add_child(line)
	for y in range(gameMap.height + 1):
		var line = Line2D.new()
		line.default_color = Color.GRAY
		line.width = Global.UNIT_EDGE
		line.add_point(Vector2(0 + Global.UNIT_EDGE, y * Global.UNIT_SIZE + Global.UNIT_EDGE))
		line.add_point(Vector2(gameMap.width * Global.UNIT_SIZE + Global.UNIT_EDGE, y * Global.UNIT_SIZE + Global.UNIT_EDGE))
		Grids.add_child(line)
	
	
	

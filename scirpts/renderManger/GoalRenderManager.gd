class_name GoalRenderManger
extends Node

static func refresh():
	var goal = Game.Instance.get_node("Goal").get_node("Box")
	Global.clear_children(goal)
	
	var shapeObject = ShapeObject.new(Game.Instance.curLevel.goal)
	var node = Global.createShapeNode(shapeObject, 1, 1)
	goal.add_child(node)
	
	var size = shapeObject.curShape.shapeSizeI()
	
	for x in range(size.x + 1):
		var line = preload("res://nodes/dotline.tscn").instantiate()
		line.default_color = Color.GRAY
		#line.width = Global.UNIT_EDGE
		line.clear_points()
		line.add_point(Vector2(x * Global.UNIT_SIZE_2, 0))
		line.add_point(Vector2(x * Global.UNIT_SIZE_2, size.y * Global.UNIT_SIZE_2))
		goal.add_child(line)
	for y in range(size.y + 1):
		var line = preload("res://nodes/dotline.tscn").instantiate()
		line.default_color = Color.GRAY
		#line.width = Global.UNIT_EDGE
		line.clear_points()
		line.add_point(Vector2(0, y * Global.UNIT_SIZE_2))
		line.add_point(Vector2(size.x * Global.UNIT_SIZE_2, y * Global.UNIT_SIZE_2))
		goal.add_child(line)
	

static func isWin()->bool:
	var goal = Game.Instance.curLevel.goal
	return WorkspaceRenderManager.workspaceToShape(false).isSameWith(goal)

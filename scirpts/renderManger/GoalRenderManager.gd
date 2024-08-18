class_name GoalRenderManger
extends Node

static func refresh():
	var goal = Game.Instance.get_node("Goal").get_node("Box")
	Global.clear_children(goal)
	
	var shapeObject = ShapeObject.new(Game.Instance.curLevel.goal)
	var node = Global.createShapeNode(shapeObject, 1, 1)
	goal.add_child(node)
	

static func isWin()->bool:
	var goal = Game.Instance.curLevel.goal
	
	return WorkspaceRenderManager.workspaceToShape().isSameWith(goal)

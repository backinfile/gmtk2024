class_name OptionRenderManager
extends Node

static var optionList:Array[ShapeNode] = []

static func refresh():
	var optionPanel = Game.Instance.optionPanel
	var vbox = optionPanel.get_child(0)
	
	optionList.clear()
	Global.clear_children(vbox)
	
	var curLevel = Game.Instance.curLevel
	for index in range(curLevel.shapes.size()):
		var shape = curLevel.shapes[index]
		var count = curLevel.shapesCount[index]
		var shapeObject = ShapeObject.new(shape)
		var btn = preload("res://nodes/material_button.tscn").instantiate()
		vbox.add_child(btn)
		var node = Global.createShapeNode(shapeObject, count)
		node.optionIndex = index
		optionList.append(node)
		btn.count = count
		btn.node = node
		btn.pressed.connect(func (): on_select(node))
		#if index == 0:
			#Game.Instance.curSelectedShape = node
		print(node.shape.curShape.area)
	
static func on_select(node:ShapeNode):
	var index = node.optionIndex
	if Game.Instance.curSelectedShape == node:
		Game.Instance.curSelectedShape = null
		print("lose curSelectedShape to ", index)
	else:
		if node.count > 0:
			Game.Instance.curSelectedShape = node
			print("change curSelectedShape to ", index)
		else:
			print("miss shape count")

static func modifyCurSelectCount(node:ShapeNode, modify:int):
	node = optionList[node.optionIndex]
	print("modifyCurSelectCount  modify = ", modify, " nodeIndex = ", node.optionIndex)
	node.count += modify
	if node.count < 0: node.count = 0
	if node.count <= 0:
		if Game.Instance.curSelectedShape == node:
			print("lose curSelectedShape by reduce count")
			Game.Instance.curSelectedShape = null
			#ControlManager.onDrawStart(false)
	

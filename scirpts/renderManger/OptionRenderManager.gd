class_name OptionRenderManager
extends Node

static var optionShapeList:Array[ShapeNode] = []
static var optionBtnList:Array[MeterialButton] = []

static func refresh():
	var optionPanel = Game.Instance.optionPanel
	var vbox = optionPanel.get_child(0).get_child(0)
	
	optionShapeList.clear()
	optionBtnList.clear()
	Global.clear_children(vbox)
	
	var curLevel = Game.Instance.curLevel
	Global.COLORS.shuffle()
	for index in range(curLevel.shapes.size()):
		var shape = curLevel.shapes[index]
		var count = curLevel.shapesCount[index]
		var shapeObject = ShapeObject.new(shape)
		var btn = preload("res://nodes/material_button.tscn").instantiate()
		vbox.add_child(btn)
		var node = Global.createShapeNode(shapeObject, count, 2)
		node.optionIndex = index
		optionShapeList.append(node)
		optionBtnList.append(btn)
		btn.count = count
		btn.node = node
		btn.color = Global.COLORS[index % Global.COLORS.size()]
		
		btn.pressed.connect(func (): on_select(node))
		if index == 0:
			Game.Instance.curSelectedShape = node
			btn.selected = true
			WorkspaceRenderManager.refreshHoverDotline()
		print(node.shape.curShape.area)
	
static func on_select(node:ShapeNode):
	var index = node.optionIndex
	var btn = optionBtnList[node.optionIndex]
	if Game.Instance.curSelectedShape == node:
		Game.Instance.curSelectedShape = null
		btn.selected = false
		print("lose curSelectedShape to ", index)
	else:
		if Game.Instance.curSelectedShape:
			var otherBtn = optionBtnList[Game.Instance.curSelectedShape.optionIndex]
			otherBtn.selected = false
		if node.count > 0:
			Game.Instance.curSelectedShape = node
			btn.selected = true
			print("change curSelectedShape to ", index)
		else:
			print("miss shape count")
	WorkspaceRenderManager.refreshHoverDotline()

static func modifyCurSelectCount(node:ShapeNode, modify:int):
	node = optionShapeList[node.optionIndex]
	var btn = optionBtnList[node.optionIndex]
	print("modifyCurSelectCount  modify = ", modify, " nodeIndex = ", node.optionIndex)
	node.count += modify
	btn.count = node.count
	if node.count < 0: node.count = 0
	if node.count <= 0:
		if Game.Instance.curSelectedShape == node:
			print("lose curSelectedShape by reduce count")
			Game.Instance.curSelectedShape = null
			btn.selected = false
			#ControlManager.onDrawStart(false)
	# repick last node
	if modify > 0 and Game.Instance.curSelectedShape == null:
		Game.Instance.curSelectedShape = node
		btn.selected = true
	WorkspaceRenderManager.refreshHoverDotline()
			

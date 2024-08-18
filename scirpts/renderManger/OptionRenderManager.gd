class_name OptionRenderManager
extends Node


static func refresh():
	var optionPanel = Game.Instance.optionPanel
	var vbox = optionPanel.get_child(0)
	
	Global.clear_children(vbox)
	
	var curLevel = Game.Instance.curLevel
	for index in range(curLevel.shapes.size()):
		var shape = curLevel.shapes[index]
		var count = curLevel.shapesCount[index]
		var shapeObject = ShapeObject.new(shape)
		var btn = Button.new()
		var node = Global.createShapeNode(shapeObject, count)
		btn.custom_minimum_size = shapeObject.curShape.shapeSize() * Global.UNIT_SIZE
		btn.add_child(node)
		btn.pressed.connect(func ():
			Game.Instance.curSelectedShape = node
			print("change curSelectedShape to ", index)
			)
		print(node.shape.curShape.area)
		if Game.Instance.curSelectedShape == null:
			Game.Instance.curSelectedShape = node
		vbox.add_child(btn)
	

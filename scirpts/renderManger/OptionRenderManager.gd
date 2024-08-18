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
		btn.add_child(node)
		btn.custom_minimum_size = shapeObject.curShape.shapeSize() * Global.UNIT_SIZE
		btn.pressed.connect(func ():
			if Game.Instance.curSelectedShape == node:
				Game.Instance.curSelectedShape = null
				print("lose curSelectedShape to ", index)
			else:
				Game.Instance.curSelectedShape = node
				print("change curSelectedShape to ", index)
			)
		#if index == 0:
			#Game.Instance.curSelectedShape = node
		print(node.shape.curShape.area)
		vbox.add_child(btn)
	

class_name Shape
extends Resource

@export var area:Array[Vector3i] = []
var size:Vector2i = Global.InvalidPos;

enum DUR {
	UP  = 0,
	LEFT = 1,
	DOWN = 2,
	RIGHT = 3
}


func scaleUp(scale:int):
	var result = []
	for v in area:
		var x = v[0]
		var y = v[1]
		var s = Global.getShapesBySizeAndDur(scale, v[2])
		for vv in s:
			result.append(Vector3i(vv[0] + x * scale, vv[1] + y * scale, vv[2]))
	return result

func shapeSize() -> Vector2:
	if size.x < 0 || size.y < 0:
		var x = 0
		var y = 0
		for s in area:
			x = max(x, s[0])
			y = max(y, s[1])
		size = Vector2(x + 1, y + 1)
	return size

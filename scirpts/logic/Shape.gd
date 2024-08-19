class_name Shape
extends Resource


@export var area: Array[Vector3i] = []
var size:Vector2i = Global.InvalidPos;

enum DUR {
	UP  = 0,
	LEFT = 1,
	DOWN = 2,
	RIGHT = 3
}


func get_size() -> Vector2i:
	var width: int = 0
	var height: int = 0
	for pos in area:
		width = max(width, pos[0])
		height = max(height, pos[1])
	return Vector2i(width, height)


func isSameWith(shape:Shape)->bool:
	if shape == null: return false
	if shape.area.size() != area.size(): return false
	var map = {}
	for v in area:
		map[v] = true
	for v in shape.area:
		if v not in map:
			return false
		map.erase(v)
	return true

# 将图形分解成若干连续图形
func split() -> Array[Array]:
	var result : Array[Array] = []
	var _area := area.duplicate()
	var queue = []
	while _area.size() > 0 or queue.size() > 0:
		if not queue:
			queue = [_area.pop_back()]
			result.append([])
		var _queue = queue.duplicate()
		queue.clear()
		for a in _queue:
			_area.erase(a)
			result[-1].append(a)
			var list 
			var x = a.x
			var y = a.y
			match a.z:
				0: 
					list = [Vector3i(x, y - 1, 2), Vector3i(x, y, 1), Vector3i(x, y, 3)]
				1:
					list = [Vector3i(x - 1, y, 3), Vector3i(x, y, 0), Vector3i(x, y, 2)]
				2:
					list = [Vector3i(x, y + 1, 0), Vector3i(x, y, 3), Vector3i(x, y, 1)]
				3:
					list = [Vector3i(x + 1, y, 1), Vector3i(x, y, 2), Vector3i(x, y, 0)]
			
			for _a in list:
				if _a in _area:
					_area.erase(_a)
					queue.append(_a)
		
	return result

# 获得图形的所有顶点并按顺序排列。该图形必须是连续图形
func get_outline() -> Array[Array]:
	var areas = split()
	var result : Array[Array] = []
	for area in areas:
		result.append(get_continous_outline(area))
	return result

# 获得图形的所有顶点并按顺序排列。该图形必须是连续图形
static func get_continous_outline(area: Array) -> Array[Vector2]:
	var borders = {}
	for a: Vector3i in area:
		var b_list := []
		var x = a.x
		var y = a.y
		match a.z:
			0:
				b_list = [Vector3i(x, y, 0), Vector3i(x, y, 2), Vector3i(x, y, 5)]
			1:
				b_list = [Vector3i(x, y, 1), Vector3i(x, y, 2), Vector3i(x, y, 3)]
			2:
				b_list = [Vector3i(x, y, 3), Vector3i(x, y, 4), Vector3i(x, y + 1, 0)]
			3:
				b_list = [Vector3i(x, y, 4), Vector3i(x, y, 5), Vector3i(x + 1, y, 1)]
		for b in b_list:
			borders[b] = not borders.get(b, false)
	var border_points = []
	for b in borders:
		if borders[b]:
			var x = b.x
			var y = b.y
			var ps = []
			match b.z:
				0:
					ps = [Vector2(x, y), Vector2(x + 1, y)]
				1:
					ps = [Vector2(x, y), Vector2(x, y + 1)]
				2:
					ps = [Vector2(x, y), Vector2(x + .5, y + .5)]
				3:
					ps = [Vector2(x, y + 1), Vector2(x + .5, y + .5)]
				4:
					ps = [Vector2(x + 1, y + 1), Vector2(x + .5, y + .5)]
				5:
					ps = [Vector2(x + 1, y), Vector2(x + .5, y + .5)]
			border_points.append(ps)

	var points : Array[Vector2] = []
	var p = border_points[0][0]
	for i in border_points.size():
		var flag = true
		for j in border_points.size():
			var _b = border_points[j]
			if p in _b:
				_b.erase(p)
				p = _b[0]
				border_points.remove_at(j)
				flag = false
				break
		if flag:
			break
		points.append(p)
	return points

func scaleUp(scale:int):
	var result = []
	for v in area:
		var x = v[0]
		var y = v[1]
		var s = Global.getShapesBySizeAndDur(scale, v[2])
		for vv in s:
			result.append(Vector3i(vv[0] + x * scale, vv[1] + y * scale, vv[2]))
	var shape = Shape.new()
	shape.area.append_array(result)
	return shape


func getNegOffset() -> Vector2i:
	var minX = 0
	var minY = 0
	for v in area:
		minX = min(v[0], minX)
		minY = min(v[1], minY)
	return Vector2i(-minX, -minY)

func moveOffset(offset:Vector2i) -> Shape:
	var shape = Shape.new()
	for v in area:
		shape.area.append(Vector3i(v[0] + offset.x, v[1] + offset.y, v[2]))
	return shape

# coor can be neg
func rotate(r:int) -> Shape:
	if (r == 0): return self.duplicate()
	if (r == 45 or r == -45 or r == 135 or r == -135):
		return _rotateAngle(r)
	return _rotateFixed(r)
	

func _rotateFixed(r:int):
	var shape = Shape.new()
	for v in area:
		var p = _rotatePositionFixed(v[0], v[1], r)
		shape.area.append(Vector3i(p.x, p.y, _rotateShapeTypeFixed(v[2], r)))
	return shape


	

func _rotateAngle(r:int):
	pass

func _get_rotate_offset_angle(r:int):
	match r:
		45: return Vector2i.ZERO

func _rotatePositionFixed(x, y, r:int):
	match r:
		90: return Vector2i(- y - 1, x)
		180: return Vector2i(- x - 1, - y - 1)
		-90:  return Vector2(y , -x - 1)
	return Vector2i(x, y)

func _rotateShapeTypeFixed(dir, r:int):
	match r:
		90: return (dir + 3) % 4
		180: return (dir + 2) % 4
		-90: return (dir + 1) % 4
	return dir
	

func shapeSize() -> Vector2:
	if size.x < 0 || size.y < 0:
		var x = 0
		var y = 0
		for s in area:
			x = max(x, s[0])
			y = max(y, s[1])
		size = Vector2(x + 1, y + 1)
	return size

func shapeSizeI() -> Vector2:
	if size.x < 0 || size.y < 0:
		var x = 0
		var y = 0
		for s in area:
			x = max(x, s[0])
			y = max(y, s[1])
		size = Vector2i(x + 1, y + 1)
	return size

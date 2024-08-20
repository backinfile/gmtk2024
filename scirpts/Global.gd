extends Node

var UNIT_SIZE = 50;
var UNIT_SIZE_2 = 50;
var UNIT_EDGE = 1;

var workspace_dotline_color := Color(0, 0, 0, .5)
var workspace_dotline_width := 20
var workspace_outline_color := Color("609CD8")
var select_color: Color

var workspace_rotate_angle_offset = 45

var COLORS = [
	Color("719FD5"),
	Color("D96564"),
	Color("D8894E"),
	Color("CF67A4"),
	Color("8BC567"),
	Color("71C6C8"),
]

@onready var shape_node_tscn:PackedScene = load("res://nodes/shape_node.tscn");
var InvalidPos = Vector2(-1, -1)

func createShapeNode(shape:ShapeObject, count = 1, scaleMode = 0):
	var node:ShapeNode = shape_node_tscn.instantiate()
	node.init(shape, count, scaleMode);
	print("createShapeNode")
	return node;
	
func getShapesBySizeAndDur(size:int, dur:int):
	#print("getShapesBySizeAndDur size = ", size, " dur = ", dur)
	if size == 1:
		return [Vector3i(0,0, dur)]
	elif size == 2:
		match dur:
			Shape.DUR.UP: 
				return [Vector3i(0,0,0), Vector3i(0,0,3), Vector3i(1,0,0), Vector3i(1,0,1)]
			Shape.DUR.LEFT: 
				return [Vector3i(0,0,1), Vector3i(0,0,2), Vector3i(0,1,0), Vector3i(0,1,1)]
			Shape.DUR.DOWN: 
				return [Vector3i(0,1,2), Vector3i(0,1,3), Vector3i(1,1,2), Vector3i(1,1,1)]
			Shape.DUR.RIGHT: 
				return [Vector3i(1,1,3), Vector3i(1,1,0), Vector3i(1,0,3), Vector3i(1,0,2)]
	
	if size % 2 == 1:
		var ori_dx = 0
		var ori_dy = 0
		var dx = 1 if dur == Shape.DUR.UP or dur == Shape.DUR.DOWN else 0
		var dy = 1 - dx
		if dur == Shape.DUR.DOWN: ori_dy += 1
		if dur == Shape.DUR.RIGHT: ori_dx += 1
		var sub = getShapesBySizeAndDur(size - 1, dur)
		var result = {}
		for v in sub:
			result[Vector3i(v[0] + ori_dx, v[1] + ori_dy, v[2])] = true
			result[Vector3i(v[0] + dx + ori_dx, v[1] + dy + ori_dy, v[2])] = true
		result[Vector3i(size / 2, size / 2, dur)] = true
		var offset = getDurOffsetPos(dur)
		result[Vector3i(size / 2 + offset.x, size / 2 + offset.y, (dur + 2) % 4)] = true
		return Array(result.keys())
	else:
		var ori_dx = 0
		var ori_dy = 0
		if dur == Shape.DUR.DOWN: ori_dy += 1
		if dur == Shape.DUR.RIGHT: ori_dx += 1
		var dx = 1 if dur == Shape.DUR.UP or dur == Shape.DUR.DOWN else 0
		var dy = 1 - dx
		var sub = getShapesBySizeAndDur(size - 1, dur)
		var result = {}
		for v in sub:
			result[Vector3i(v[0] + ori_dx, v[1] + ori_dy, v[2])] = true
			result[Vector3i(v[0] + dx + ori_dx, v[1] + dy + ori_dy, v[2])] = true
		var mid = size / 2
		match dur:
			Shape.DUR.UP: 
				result[Vector3i(mid - 1, mid - 1, 3)] = true
				result[Vector3i(mid, mid - 1, 1)] = true
			Shape.DUR.LEFT: 
				result[Vector3i(mid - 1, mid - 1, 2)] = true
				result[Vector3i(mid - 1, mid, 0)] = true
			Shape.DUR.DOWN: 
				result[Vector3i(mid - 1, mid, 3)] = true
				result[Vector3i(mid, mid, 1)] = true
			Shape.DUR.RIGHT: 
				result[Vector3i(mid, mid - 1, 2)] = true
				result[Vector3i(mid, mid, 0)] = true
		return Array(result.keys())


func getDurOffsetPos(dur:int):
	match dur:
		Shape.DUR.UP: return Vector2i.UP
		Shape.DUR.LEFT: return Vector2i.LEFT
		Shape.DUR.DOWN: return Vector2i.DOWN
		Shape.DUR.RIGHT: return Vector2i.RIGHT
		
func clear_children(node:Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func toVector2i(v:Vector2i):
	return Vector2i(roundi(v.x), roundi(v.y))

func div(v: Vector2i, v2:Vector2i) -> Vector2i:
	return Vector2i(v.x / v2.x, v.y / v2.y)

func playSoundEffect(name: String):
	print(name)
	SoundEffectPlayer.stream = load("res://assets/audio/%s.mp3" % name)
	SoundEffectPlayer.play() 

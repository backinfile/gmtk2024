class_name Shape
extends Resource

@export var area: Array[Vector3i] = []

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

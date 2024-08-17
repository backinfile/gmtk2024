extends Control

func _ready():
  var shape := Shape.new()
  shape.area.append(Vector3i(0, 0, 0))
  shape.area.append(Vector3i(0, 0, 1))
  shape.area.append(Vector3i(0, 0, 2))
  shape.area.append(Vector3i(1, 0, 1))
  print("测试图形：", shape.area)
  print("分割后图形：", shape.split())
  print("轮廓：", shape.get_outline())

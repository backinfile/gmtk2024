class_name ShapeNode
extends Control

var shape:ShapeObject;
var count = -1;

var dragging = false;
var draggable = false;
var onDrag = null;  # onDrag(bool dragStart)
#var onDragCancel = null; # onDragCancel

var shapeCenterPosition:Vector2 = Vector2.ZERO

func init(shape:ShapeObject, count = -1):
  self.shape = shape;
  self.count = count;
  #ShapeUtils.recreateShape(self)
  findShapeCenterPosition()

func _ready():
  setDragState(true)
  pass

func setDragState(draggable:bool, onDrag:Callable = func (d):pass):
  self.draggable = draggable
  self.onDrag = onDrag
  
func findShapeCenterPosition():
  var x = 0.0
  var y = 0.0
  for s in shape.curShape.area:
    x = max(x, s[0])
    y = max(y, s[1])
  shapeCenterPosition = Vector2((x + 1) / 2, (y + 1) / 2)
  print("shapeCenterPosition ", shapeCenterPosition)
  


func _process(delta):
  if dragging:
    self.global_position = get_viewport().get_mouse_position() - shapeCenterPosition * Global.UNIT_SIZE;
    

func _on_gui_input(ev):
  if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
    if ev.pressed:
      if draggable and !dragging:
        dragging = true
        if onDrag: onDrag.call(true)
    else:
      if dragging:
        if onDrag: onDrag.call(false)
        dragging = false

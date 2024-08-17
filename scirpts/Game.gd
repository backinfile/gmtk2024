extends Control


#var shapesInSelectPancel:Array[ShapeNode] = []
#var shapesInOptionPancel:Array[ShapeNode] = []
#var shapesInWorkSpace:Array[ShapeNode] = []

@export var curLevel:Level;
var gameMap:GameMap;
var curSelectedShape:ShapeObject;

@onready var workSpace = $WorkSpace/Control
@onready var selectPancel = $SelectPanel/Control


func _ready():
  gameMap = GameMap.new();
  for index in range(curLevel.shapes.size()):
    var shape = curLevel.shapes[index]
    var count = curLevel.shapesCount[index]
    var shapeObject = ShapeObject.new(shape)
    selectPancel.add_child(Global.createShapeNode(shapeObject, count))

func _process(delta):
  pass

class_name TransitionButton
extends Button

@export var normal_color: Color = Color(1, 1, 1, 1)
@export var hover_color: Color = Color(.8, .8, .8)
@export var pressed_color: Color = Color(.6, .6, .6)
@export var disabled_color: Color = Color(.5, .5, .5, .5)
@export var transition: float = .1
var state: DrawMode:
  set(value):
    if state != value:
      state = value
      var color: Color 
      match state:
        DrawMode.DRAW_NORMAL:
          color = normal_color
        DrawMode.DRAW_HOVER:
          color = hover_color
        DrawMode.DRAW_PRESSED:
          color = pressed_color
        DrawMode.DRAW_DISABLED:
          color = disabled_color
        DrawMode.DRAW_HOVER_PRESSED:
          color = pressed_color
      var tween = create_tween()
      tween.tween_property(self, "modulate", color, transition)

func _draw() -> void:
  state = get_draw_mode()

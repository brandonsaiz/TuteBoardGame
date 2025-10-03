extends Camera2D
class_name TransitionCamera

@onready var top_left = $Node/TopLeft
@onready var bottom_right = $Node/BottomRight
@export var transition_lag := 3.0
var transitioning = false

func _ready():
	limit_left = top_left.position.x
	limit_top = top_left.position.y
	limit_right = bottom_right.position.x
	limit_bottom = bottom_right.position.y
	enabled = false

func transition(from : Camera2D, to: Camera2D):
	if transitioning: return
	transitioning = true
	global_position = from.global_position
	enabled = true
	from.enabled = false	
	var tween = create_tween()
	tween.tween_property(self, "global_position", to.global_position, transition_lag)
	await tween.finished
	enabled = false
	to.enabled = true	
	transitioning = false

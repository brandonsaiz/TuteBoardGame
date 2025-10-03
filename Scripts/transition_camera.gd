extends Camera2D
class_name TransitionCamera

@onready var top_left = $Node/TopLeft
@onready var bottom_right = $Node/BottomRight
@export var transition_speed := 1.0
var transitioning: bool = false

func _ready():
	enabled = true
	limit_left = top_left.global_position.x
	limit_top = top_left.global_position.y
	limit_right = bottom_right.global_position.x
	limit_bottom = bottom_right.global_position.y
	
func transition(from: Camera2D, to: Camera2D):
	if transitioning: return
	global_position = from.global_position		
	enabled = true
	from.enabled = false
	transitioning = true	
#	print("mine: " + str(global_position)\
#			+ ", from: " +str(from.global_position)\
#			+ ", to: " + str(to.global_position))
	var tween = create_tween()
	tween.tween_property(self, "global_position", to.global_position, transition_speed)
	await(tween.finished)
	to.enabled = true
	enabled = false
#	transitioning = false
#	print("mine: " + str(global_position)\
#			+ ", from: " +str(from.global_position)\
#			+ ", to: " + str(to.global_position))

	
	
	
	
	
	

extends Camera2D
class_name PlayerCamera

@onready var top_left = $Node/TopLeft
@onready var bottom_right = $Node/BottomRight

func _ready():
	limit_left = top_left.position.x
	limit_top = top_left.position.y
	limit_right = bottom_right.position.x
	limit_bottom = bottom_right.position.y
	

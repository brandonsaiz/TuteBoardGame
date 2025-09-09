extends Marker2D
class_name Space

@export var type : SpaceType.type
var posit : Vector2

func _ready() -> void:
	posit = global_position

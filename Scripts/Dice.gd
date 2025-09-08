class_name Dice
extends AnimatedSprite2D

@onready var roll_timer = $rollTimer
@onready var roll_camera = $rollCamera

var result : int

signal roll_complete()

func _ready() -> void:
	randomize()
	frame = randi_range(0, 5)
	
#func _input(event):
#	if Input.is_action_just_pressed("ui_accept"):
#		print(str(roll()))
	
func roll() -> int:
	roll_timer.wait_time = randf_range(1, 2)
	roll_timer.start()
	play("default")
	result = randi_range(0, 5)
	return result + 1

func _on_roll_timer_timeout() -> void:
	stop()
	frame = result
	emit_signal("roll_complete")

class_name Dice
extends Sprite2D

@onready var roll_timer = $rollTimer
@onready var roll_camera = $rollCamera
@onready var animation_player = $AnimationPlayer

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
	animation_player.play("default")
	result = randi_range(0, 5)
	return result + 1

func _on_roll_timer_timeout() -> void:
	animation_player.stop()
	frame = result
	emit_signal("roll_complete")

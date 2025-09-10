extends Control

@export var left_button_correct : bool

signal answered(correct : bool)

func _on_left_button_pressed():
	emit_signal("answered", left_button_correct)
	if left_button_correct: print("correct")
	else: print("incorrect")
	
func _on_right_button_pressed():
	emit_signal("answered", !left_button_correct)
	if !left_button_correct: print("correct")
	else: print("incorrect")

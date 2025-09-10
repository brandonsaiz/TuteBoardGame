extends Control

@onready var hbox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var question = $PanelContainer/MarginContainer/VBoxContainer/Question
@onready var close_timer = $CloseTimer

@export var left_button_correct : bool

signal answered(correct : bool)

func _on_left_button_pressed():
	emit_signal("answered", left_button_correct)
#	if left_button_correct: print("correct")
#	else: print("incorrect")
	
func _on_right_button_pressed():
	emit_signal("answered", !left_button_correct)
#	if !left_button_correct: print("correct")
#	else: print("incorrect")


func _on_answered(correct):
	hbox.visible = false
	if correct: question.text = "That's correct!"
	else: question.text = "Wrong!"
	close_timer.start()
	
func _on_close_timer_timeout():
	queue_free()

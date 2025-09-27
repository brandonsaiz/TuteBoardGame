extends Control
class_name QuestionBox

@onready var hbox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var question = $PanelContainer/MarginContainer/VBoxContainer/Question
@onready var close_timer = $CloseTimer
@onready var sound_player = $questionSoundPlayer

var start = preload("res://sounds/board game question comes up.wav")
var right = preload("res://sounds/board game question right.wav")
var wrong = preload("res://sounds/board game question wrong.wav")

@export var left_button_correct : bool

signal answered(correct : bool)

func _ready():
	sound_player.stream = start
	sound_player.play()

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
	if correct: 
		question.text = "That's correct!"
		sound_player.stream = right
	else: 
		question.text = "Wrong!"
		sound_player.stream = wrong
	sound_player.play()
	close_timer.start()
	
func _on_close_timer_timeout():
	queue_free()

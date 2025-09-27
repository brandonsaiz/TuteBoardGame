extends CenterContainer
class_name RollForFirst

@onready var texture_rect = $PanelContainer/VBoxContainer/TextureRect
@onready var button = $PanelContainer/VBoxContainer/Button
@onready var label = $PanelContainer/VBoxContainer/Label
@onready var animation_player = $AnimationPlayer
@onready var anim_timer = $AnimTimer

var blue_piece = preload("res://Art/blue piece.png")
var pink_piece = preload("res://Art/pink piece.png")
var piece_string: String


signal piece_picked(piece: String)

func _on_button_pressed():
	anim_timer.start()
	animation_player.play("player_flip")
	button.disabled = true
	var which_piece: int = randi_range(0, 1)
	match which_piece:
		0: piece_string = "Pink"
		1: piece_string = "Blue"


func _on_anim_timer_timeout():	
	animation_player.stop()
	emit_signal("piece_picked", piece_string.to_lower())
	label.text = piece_string + " piece goes first!"
	match piece_string:
		"Pink": texture_rect.texture = pink_piece
		"Blue": texture_rect.texture = blue_piece	

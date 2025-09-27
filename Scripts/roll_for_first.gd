extends CenterContainer

@onready var texture_rect = $PanelContainer/VBoxContainer/TextureRect
@onready var button = $PanelContainer/VBoxContainer/Button
@onready var label = $PanelContainer/VBoxContainer/Label

var blue_piece = preload("res://Art/blue piece.png")
var pink_piece = preload("res://Art/pink piece.png")

signal piece_picked(piece: String)

func _on_button_pressed():
	button.disabled = true
	var which_piece: int = randi_range(0, 1)
	var piece_string: String
	match which_piece:
		0: 
			texture_rect.texture = pink_piece
			piece_string = "Pink"
		1: 
			texture_rect.texture = blue_piece	
			piece_string = "Blue"
			
	emit_signal("piece_picked", piece_string.to_lower())
	label.text = piece_string + " piece goes first!"

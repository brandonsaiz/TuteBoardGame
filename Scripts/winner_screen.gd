extends CenterContainer

@onready var label = $PanelContainer/VBoxContainer/Label as Label
@onready var texture_rect = $PanelContainer/VBoxContainer/TextureRect as TextureRect

var player_one_file: String = "res://Art/blue piece.png"
var player_two_file: String = "res://Art/pink piece.png"

func set_winner(player_one: bool) -> void:
	if player_one:
		texture_rect.texture = player_one_file
	else: texture_rect.texture = player_two_file

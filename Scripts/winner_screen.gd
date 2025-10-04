extends CenterContainer
class_name  WinnerScreen

@onready var label = $PanelContainer/VBoxContainer/Label as Label
@onready var texture_rect = $PanelContainer/VBoxContainer/TextureRect as TextureRect

var player_one_file: String = "res://Art/blue piece.png"
var player_two_file: String = "res://Art/pink piece.png"
var both_file: String = "res://Art/both.png"

func flip_players():
	var tmp = player_two_file
	player_one_file = player_two_file
	player_two_file = player_one_file
func change_text(string: String):
	label.text = string

func set_tie() -> void:
	texture_rect.texture = load(both_file)
	visible = true
func set_winner(player_one: bool) -> void:
#	print("did i get here? set winner")
	if player_one:
		label.text = "Player One Wins!"
		texture_rect.texture = load(player_one_file)
	else:
		label.text = "Player Two Wins!" 
		texture_rect.texture = load(player_two_file)
	visible = true


func _on_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

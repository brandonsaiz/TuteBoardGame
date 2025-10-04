extends CenterContainer

@onready var button_one = $PanelContainer/VBoxContainer/GridContainer/ButtonOne
@onready var button_two = $PanelContainer/VBoxContainer/GridContainer/ButtonTwo

func _ready():
	button_two.disabled = !SceneManager.boards_completed[0]

func _on_button_one_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_button_two_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_2.tscn")

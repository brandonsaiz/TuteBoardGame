extends Node2D

@onready var game_board = $GameBoard
@onready var dice = $Dice as Dice
@onready var player_one = $PlayerOne
@onready var player_two = $PlayerTwo

@export var token_offset : Vector2 = Vector2(0.0, 32.0)
var game_board_spots : Array

var p_one_turn : bool = true
var roll_complete : bool = false
var roll_ready : bool = true

var p_one_spot : int = 0
var p_two_spot : int = 0
var result : int


func _ready() -> void:
	dice.roll_complete.connect(_roll_complete)
	game_board_spots = game_board.get_children()
	player_one.global_position = game_board_spots[0].global_position - token_offset
	player_two.global_position = game_board_spots[0].global_position + token_offset

func _input(_event) -> void:
	if Input.is_action_just_pressed("ui_accept") && roll_ready:
		result = dice.roll()
		roll_ready = false

func _process(_delta) -> void:
	var current_player
	var current_spot
	if p_one_turn: 
		current_player = player_one
		current_spot = p_one_spot
	else: 
		current_player = player_two	
		current_spot = p_two_spot
	if roll_complete:
		move_player(current_player, current_spot)
		
		
func move_player(player : Sprite2D, spot : int):		
	var tween = create_tween()
	tween.tween_property(player, "global_position",\
			game_board_spots[spot + result].global_position, 1.0)
	await tween.finished
	roll_ready = true
	
func _roll_complete():
	roll_complete = true
	print(str(result))
#	just used to test 
#	roll_ready = true

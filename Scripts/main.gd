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
	game_board_spots = game_board.get_children() as Array[Space]
	player_one.global_position = game_board_spots[0].global_position - token_offset
	player_two.global_position = game_board_spots[0].global_position + token_offset

func _input(_event) -> void:
	if Input.is_action_just_pressed("ui_accept") && roll_ready:
		result = dice.roll()
		roll_ready = false

func _process(_delta) -> void:
	if roll_complete:
		roll_complete = false
		
		result = 5
		print(str(result))
		move_player()
		
func move_player():
	var current_player
	var spaces = 0
	var landing_space
	var final_spot
	if p_one_turn: 
		current_player = player_one
		token_offset = -1 * abs(token_offset)
		final_spot = p_one_spot + result
	else: 
		current_player = player_two
		token_offset = abs(token_offset)
		final_spot = p_two_spot + result
	
	if final_spot > game_board_spots.size()-1:
		print("fuuuuck")
		p_one_turn = !p_one_turn
		roll_ready = true
		return
		
	while spaces != result:
		if result > 0: spaces += 1
		else: spaces -= 1
		var next_spot
		if p_one_turn:
			p_one_spot += 1 * signi(result)
			next_spot = p_one_spot
		else:
			p_two_spot += 1 * signi(result)
			next_spot = p_two_spot
		var tween = create_tween()
		tween.tween_property(current_player, "global_position",\
				game_board_spots[next_spot].global_position + token_offset, 0.8)
		await tween.finished
		landing_space = game_board_spots[next_spot].type
	match landing_space:
		SpaceType.type.REGULAR:
			print("regular-ass space")
			p_one_turn = !p_one_turn
			roll_ready = true
			return
		SpaceType.type.QUESTION:
			print("question")
			return
		SpaceType.type.BACKWARD:
			print("backwards")
			result = -2
			move_player()
			return
		SpaceType.type.FORWARD:
			print("forwards")
			result = 2
			move_player()
			return
		SpaceType.type.FINISH:
			print("end")
		
		
	
func _roll_complete():
	roll_complete = true
#	just used to test 
#	roll_ready = true

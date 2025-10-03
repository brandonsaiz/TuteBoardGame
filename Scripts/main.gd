extends Node2D

@onready var game_board = $GameBoard
@onready var dice = $CanvasLayer/Dice as Dice
@onready var player_one = $PlayerOne as Sprite2D
@onready var player_two = $PlayerTwo as Sprite2D
@onready var camera_one= $PlayerOne/Camera as PlayerCamera
@onready var camera_two = $PlayerTwo/Camera as PlayerCamera
@onready var transition_camera = $TransitionCamera as TransitionCamera

@onready var canvas_layer = $CanvasLayer

@onready var end_turn_timer = $EndTurnTimer
@onready var movement_timer = $MovementTimer
@onready var action_timer = $ActionTimer
@onready var action_label_ctr = $CanvasLayer/ActionLabelCtr
@onready var score_ctr = $CanvasLayer/ScoreCtr
@onready var action_label = $CanvasLayer/ActionLabelCtr/CenterContainer/MarginContainer/ActionLabel
@onready var score_one_label = $CanvasLayer/ScoreCtr/MarginContainer/VBoxContainer/ScoreOneLabel
@onready var score_two_label = $CanvasLayer/ScoreCtr/MarginContainer/VBoxContainer/ScoreTwoLabel
@onready var winner_screen = $"CanvasLayer/Winner Screen" as WinnerScreen
@onready var roll_for_first = $"CanvasLayer/Roll For First"

@onready var piece_sound = $PieceSound

@export var debug: bool = false
@export var debug_dice_roll: int = 6
@export var debug_piece_speed: float = 0.001

@export var question_boxes : Array[PackedScene]
@export var token_offset : Vector2 = Vector2(0.0, 32.0)

var game_board_spots : Array 
var p_one_turn : bool = true
var roll_complete : bool = false
var roll_ready : bool = false
var p_one_spot : int = 0
var p_two_spot : int = 0
var result : int
var p_one_score : int = 0
var p_two_score : int = 0
var p_one_done : bool = false
var p_two_done : bool = false
var score_words_one : String = "Blue - Player One Score: "
var score_words_two : String = "Pink - Player Two Score: "


func _ready() -> void:
	roll_for_first.piece_picked.connect(_start_game)
	dice.roll_complete.connect(_roll_complete)
	game_board_spots = game_board.get_children() as Array[Space]
	player_one.global_position = game_board_spots[0].global_position - token_offset
	player_two.global_position = game_board_spots[0].global_position + token_offset
	score_one_label.text = score_words_one + str(p_one_score)
	score_two_label.text = score_words_two + str(p_two_score)

func _input(_event) -> void:
	if Input.is_action_just_pressed("ui_accept") && roll_ready:
		result = dice.roll()
		roll_ready = false

func _process(_delta) -> void:
	if !transition_camera.transitioning: _check_cameras()
	if roll_complete:
		roll_complete = false
############## DEBUG MOVEMENT ##############
		if debug:
			result = debug_dice_roll
############################################
#		print(str(result))
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
		action_timer.start()	
		action_label_ctr.visible = true
		action_label.text = "Too far!"
		if !action_timer.is_stopped():
			await action_timer.timeout
		end_turn_timer.start()
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
		var token_speed = 0.8
		############### DEBUG MOVE SPEED#####################
		if debug:
			token_speed = debug_piece_speed
		#####################################################
		var tween = create_tween()
		tween.tween_property(current_player, "global_position",\
				game_board_spots[next_spot].global_position + token_offset, token_speed)
		tween.finished.connect(piece_sound.play)
		await tween.finished		
		movement_timer.start()
		if !movement_timer.is_stopped():
			await movement_timer.timeout
		
		landing_space = game_board_spots[next_spot].type
	action_timer.start()	
	action_label_ctr.visible = true
	match landing_space:
		SpaceType.type.REGULAR:
			action_label.text = "Ready next player..."
			end_turn_timer.start()
			return
		SpaceType.type.QUESTION:
			ask_question()
			if !action_timer.is_stopped():
				await action_timer.timeout
			return
		SpaceType.type.BACKWARD:
			action_timer.start()
			action_label.text = "Move back 2 Spaces!"
			result = -2
			if !action_timer.is_stopped():
				await action_timer.timeout
			move_player()
			return
		SpaceType.type.FORWARD:
			action_timer.start()
			action_label.text = "Move forward 2 Spaces!"
			result = 2
			if !action_timer.is_stopped():
				await action_timer.timeout
			move_player()
			return
		SpaceType.type.FINISH:
			if p_one_turn: p_one_done = true
			else: p_two_done = true
			action_timer.start()
			action_label.text = "Finished!"
			end_turn_timer.start()
#			print("p1 done: " + str(p_one_done))
#			print("p2 done: " + str(p_two_done))
func player_is_frozen() -> bool:
	return p_one_done or p_two_done
			
func ask_question():
		action_label.text = "Answer the Question!"
		question_boxes.shuffle()
#		print("size of question_boxes: " + str(question_boxes.size()))
		var question_box = question_boxes.front()
#		print(str(question_box))
		var question = question_box.instantiate()
#		print(str(question))
		question.connect("answered", _on_question_answered)
		canvas_layer.add_child(question)
		
func update_score():
	score_one_label.text = score_words_one + str(p_one_score)
	score_two_label.text = score_words_two + str(p_two_score)

func _start_game(piece: String):
#	print(piece + " GOES FIRST!")
	action_timer.start()
	var pink_tex = load("res://Art/pink piece.png")
	var blue_tex = load("res://Art/blue piece.png")	
	if piece == "pink":
		player_one.texture = pink_tex
		player_two.texture = blue_tex
		score_words_one = "Pink - Player One Score: "
		score_words_two = "Blue - Player Two Score: "
	score_one_label.text = score_words_one + str(p_one_score)
	score_two_label.text = score_words_two + str(p_two_score)
	score_ctr.visible = true
	if !action_timer.is_stopped():
		await action_timer.timeout
	roll_for_first.call_deferred("queue_free")
	action_label_ctr.visible = true
	roll_ready = true
	camera_one.enabled = true
	
func _end_game():
	if p_one_score == p_two_score:
		winner_screen.set_tie()
		winner_screen.change_text("It's a tie!!!")
		return
	var winner: bool = p_one_score > p_two_score
	winner_screen.set_winner(winner)
		
func _on_turn_ended():
	if p_one_done and p_two_done:
		_end_game()
		return
	roll_ready = true
	if player_is_frozen():
#		print("one of them is done")
		p_one_turn = !p_one_done
	else:
		p_one_turn = !p_one_turn
	if p_one_turn: 
		if !camera_one.enabled:
			transition_camera.transition(camera_two, camera_one)
		action_label.text = "Roll Player One"
	else: 
		if !camera_two.enabled:
			transition_camera.transition(camera_one, camera_two)
		action_label.text = "Roll Player Two"
	action_label_ctr.visible = true
	
func _roll_complete():
	action_label_ctr.visible = false
	roll_complete = true
#	just used to test 
#	roll_ready = true

func _on_question_answered(correct : bool):
	var player
	var right_or_wrong
	var score = 10
	if correct: right_or_wrong = "correctly!"
	else: 
		right_or_wrong = "incorrectly!"
		score = 0
	if p_one_turn: 
		player = "player 1 "
		p_one_score += score
	else: 
		player = "player 2 "
		p_two_score += score
	action_label.text = player + "answered " + right_or_wrong
	action_timer.start()
	update_score()
	if !action_timer.is_stopped():
		await action_timer.timeout
	end_turn_timer.start()
	
func _check_cameras():
	print("p_one turn: " + str(p_one_turn))
	if p_one_turn && !camera_one.enabled:
		print("check cam 2")
		if camera_two.enabled:
			print("trans 2 -> 1")
			transition_camera.transition(camera_two, camera_one)
		else: camera_one.enabled = true
	if !p_one_turn && !camera_two.enabled:
		print("check cam 1")
		if camera_one.enabled:
			print("trans 2 -> 1")
			transition_camera.transition(camera_one, camera_two)
		else: camera_two.enabled = true

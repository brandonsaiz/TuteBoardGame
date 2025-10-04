extends Node
var boards_completed: Array = [false, false]

func board_completed(board: int):
	boards_completed[board-1] = true

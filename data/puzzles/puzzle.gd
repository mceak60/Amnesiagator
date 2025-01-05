class_name Puzzle
extends Node

enum Result {GREAT_SUCCESS, SUCCESS, EHHH, FAILURE}

@onready var feedback_label: RichTextLabel = $"../Feedback"
@export var change_puzzle: bool = true
@export var puzzle_list : Dictionary

var current_puzzle = 1


func check(drink: Drink) -> void:
	var puzzle = puzzle_list.get(current_puzzle).new()
	var result = puzzle.verify(drink)
	feedback_label.text = puzzle.feedback(drink, result)
	
	if change_puzzle:
		if current_puzzle == puzzle_list.size():
			print("no more puzzles")
			return
		else:
			current_puzzle += 1
	

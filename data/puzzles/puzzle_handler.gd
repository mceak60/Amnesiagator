class_name PuzzleHandler
extends Node

signal submit_drink(drink: Drink)
signal submit_drink_to(drink: Drink, customer: Customer)

@export var puzzle_list: Array[Puzzle]
@export var next_puzzle: bool = true
@export var starting_puzzle_idx = 0

@onready var draggable_mover: DraggableMover = get_parent().get_node("DraggableMover")
@onready var draggable_spawner: DraggableSpawner = get_parent().get_node("DraggableSpawner")
@onready var feedback_label: RichTextLabel = $"../Feedback"
@onready var gold_counter: Label = $"../GoldCounter"

var current_puzzle_idx = starting_puzzle_idx
 
func _ready():
	draggable_mover.submit_drink.connect(process_drink)
	draggable_mover.submit_drink_to.connect(process_drink_for)

func get_current_puzzle() -> Puzzle:
	return puzzle_list[current_puzzle_idx]

func increment_puzzle() -> void:
	if next_puzzle:
		if current_puzzle_idx == puzzle_list.size():
			assert(false, "No more puzzles.")
		else:
			current_puzzle_idx += 1

func get_puzzle_and_advance() -> Puzzle:
	var current_puzzle := get_current_puzzle()
	increment_puzzle()
	return current_puzzle

func _debug_get_puzzle_by_idx(_debug_idx: int) -> Puzzle:
	return puzzle_list[_debug_idx]

func get_puzzle_customer_match(customer: Customer, puzzle: Puzzle) -> bool:
	return puzzle.check_customer(customer)

func get_puzzle_evaluation(drink: Drink, puzzle: Puzzle) -> Puzzle.Result:
	return puzzle.evaluate_drink(drink)

func get_puzzle_feedback(drink: Drink, result: Puzzle.Result, puzzle: Puzzle) -> String:
	return puzzle.get_feedback(drink, result)

func get_puzzle_gold_reward(drink: Drink, result: Puzzle.Result, puzzle: Puzzle) -> int:
	return puzzle.get_gold_reward(drink, result)
	
func process_drink(drink: Drink) -> void:
	var current_puzzle := get_current_puzzle()
	var result: Puzzle.Result = get_puzzle_evaluation(drink, current_puzzle)
	var feedback: String = get_puzzle_feedback(drink, result, current_puzzle)
	var gold_reward: int = get_puzzle_gold_reward(drink, result, current_puzzle)
	
	var result_names := ["Great Success", "Success", "Ehhh", "Failure"]
	
	feedback_label.text = feedback
	gold_counter.text = str(int(gold_counter.text) + gold_reward)
	
	print(result_names[result])
	print(feedback)
	print("Added gold: " + str(gold_reward))
	
func process_drink_for(drink: Drink, customer: Customer) -> void:
	var current_puzzle := get_current_puzzle()
	var customer_match := get_puzzle_customer_match(customer, current_puzzle)
	if customer_match == true:
		var result: Puzzle.Result = get_puzzle_evaluation(drink, current_puzzle)
		var feedback: String = get_puzzle_feedback(drink, result, current_puzzle)
		var gold_reward: int = get_puzzle_gold_reward(drink, result, current_puzzle)
	
		var result_names := ["Great Success", "Success", "Ehhh", "Failure"]
	
		feedback_label.text = feedback
		gold_counter.text = str(int(gold_counter.text) + gold_reward)
	
		print(result_names[result])
		print(feedback)
		print("Added gold: " + str(gold_reward))
		
	else:
		feedback_label.text = "That's not my order."
		print("Gave the drink to the wrong customer...")
	
	customer.queue_free()
	draggable_spawner.spawn_customer(preload("res://data/customers/doug.tres"))

class_name PuzzleHandler
extends Node

#signal submit_drink(drink: Drink)
#signal submit_drink_to(drink: Drink, customer: Customer)

@export var puzzle_list: Array[Puzzle]
@export var next_puzzle: bool = true
@export var starting_puzzle_idx: int

# Flip to repeat same puzzle for debug, be sure to set starting puzzle idx as well
@export var debug_repeat_puzzle = false

@onready var draggable_mover: DraggableMover = get_parent().get_node("DraggableMover")
@onready var draggable_spawner: DraggableSpawner = get_parent().get_node("DraggableSpawner")
@onready var order_label: RichTextLabel = $"../Order"
@onready var feedback_label: RichTextLabel = $"../Feedback"
@onready var gold_counter: Label = $"../GoldCounter"
@onready var textbox: CanvasLayer = $"../Textbox"

var current_puzzle_idx := starting_puzzle_idx
var order_number := 1
 
func _ready():
	draggable_mover.submit_drink.connect(process_drink)
	draggable_mover.submit_drink_to.connect(process_drink_for)
	current_puzzle_idx = starting_puzzle_idx
	var current_puzzle = get_current_puzzle()
	var order = current_puzzle.get_customer_and_order()
	order_label.text = order
	textbox.queue_text(order)
	spawn_puzzle_customer(current_puzzle)

func get_current_puzzle() -> Puzzle:
	return puzzle_list[current_puzzle_idx]

func increment_puzzle() -> void:
	if debug_repeat_puzzle:
		return
	
	if next_puzzle:
		if current_puzzle_idx == puzzle_list.size() - 1:
			#assert(false, "No more puzzles.")
			current_puzzle_idx = 0
			return
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

func spawn_puzzle_customer(puzzle: Puzzle) -> void:
	var customer: Array[String] = [puzzle.customer_name, puzzle.customer_animal]
	match customer:
		["Doug", "Penguin"]:
			draggable_spawner.spawn_customer(preload("res://data/customers/doug.tres"))
		["Mark", "Owl"]:
			draggable_spawner.spawn_customer(preload("res://data/customers/mark.tres"))
		["Ziggy", "Chameleon"]:
			draggable_spawner.spawn_customer(preload("res://data/customers/ziggy.tres"))
		["Father Cornelius", "Mink"]:
			draggable_spawner.spawn_customer(preload("res://data/customers/father_cornelius.tres"))
		_:
			draggable_spawner.spawn_customer(preload("res://data/customers/test.tres"))

# SK 1/20/25 - These two methods should be refactored - if a code chunk appears identically in multiple places it is a sign it should be extricated into its own function
func process_drink(drink: Drink) -> void:
	var current_puzzle := get_current_puzzle()
	var result: Puzzle.Result = get_puzzle_evaluation(drink, current_puzzle)
	var feedback: String = get_puzzle_feedback(drink, result, current_puzzle)
	var gold_reward: int = get_puzzle_gold_reward(drink, result, current_puzzle)
	
	var result_names := ["Great Success", "Success", "Ehhh", "Failure"]
	
	feedback_label.text = feedback
	textbox.queue_text(feedback)
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
		textbox.queue_text(feedback)
		gold_counter.text = str(int(gold_counter.text) + gold_reward)
	
		SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.CUSTOMER_FEEDBACK, [customer, result], 1, .5, .25)
		SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.GOLD_ADDED)

		print(result_names[result])
		print(feedback)
		print("Added gold: " + str(gold_reward))
		
	else:
		feedback_label.text = "That's not my order."
		print("Gave the drink to the wrong customer...")
	
	SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.CUSTOMER_LEFT, [customer], 1, .5, .25)
	customer.queue_free()
	increment_puzzle()
	order_number += 1
	var new_puzzle = get_current_puzzle()
	# the next 7 lines add a waiting period and update the text box accordingly because it was jarring to just pop
	# in with the next order immediately, comment everything up to the final await function for an immediate update
	#await get_tree().create_timer(0.75).timeout
	#order_label.text = "."
	#await get_tree().create_timer(0.75).timeout
	#order_label.text = ". ."
	#await get_tree().create_timer(0.75).timeout
	#order_label.text = ". . ."
	#await get_tree().create_timer(0.75).timeout
	var new_order = new_puzzle.get_customer_and_order()
	order_label.text = new_order
	textbox.queue_text(new_order)
	spawn_puzzle_customer(new_puzzle)

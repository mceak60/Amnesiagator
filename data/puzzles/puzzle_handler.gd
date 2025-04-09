class_name PuzzleHandler
extends Node

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
@onready var textbox: Control = $"../UILayer/Textbox"

var current_puzzle_idx := starting_puzzle_idx
var order_number := 1
var global_customer: Customer

func _ready():
	draggable_mover.submit_drink.connect(process_drink)
	draggable_mover.submit_drink_to.connect(process_drink_for)
	current_puzzle_idx = starting_puzzle_idx
	var current_puzzle = get_current_puzzle()
	var order = current_puzzle.get_customer_and_order()
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
	var customer_data: Array[String] = [puzzle.customer_name, puzzle.customer_animal]
	var customer: Customer
	match customer_data:
		["Doug", "Penguin"]:
			customer = draggable_spawner.spawn_customer(preload("res://data/customers/doug/doug.tres"))
		["Mark", "Owl"]:
			customer = draggable_spawner.spawn_customer(preload("res://data/customers/mark/mark.tres"))
		["Ziggy", "Chameleon"]:
			customer = draggable_spawner.spawn_customer(preload("res://data/customers/ziggy/ziggy.tres"))
		["Father Cornelius", "Mink"]:
			customer = draggable_spawner.spawn_customer(preload("res://data/customers/father_cornelius/father_cornelius.tres"))
		_:
			customer = draggable_spawner.spawn_customer(preload("res://data/customers/test.tres"))
	customer.customer_clicked.connect(_customer_dialogue)


func process_drink(drink: Drink) -> void:
	do_process_drink(drink, get_current_puzzle())


func process_drink_for(drink: Drink, customer: Customer) -> void:
	var current_puzzle := get_current_puzzle()
	var customer_match := get_puzzle_customer_match(customer, current_puzzle)
	if customer_match == true:
		global_customer = customer
		do_process_drink(drink, current_puzzle, customer)
	else:
		textbox.queue_text(current_puzzle.customer_name + ": " + "That's not my order.")
		#feedback_label.text = "That's not my order."
		print("Gave the drink to the wrong customer...")
	
	# wait for dialogue to be progressed, then the customer leaves
	#await DialogueHandler.dialogue_ready

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.CUSTOMER_LEFT, [global_customer], 1, .5, .25)
	global_customer.queue_free()
	increment_puzzle()
	order_number += 1
	var new_puzzle = get_current_puzzle()
	
	# wait 3 seconds, then spawn the next customer and get the next puzzle
	await get_tree().create_timer(1.5).timeout
	new_puzzle.get_customer_and_order()
	spawn_puzzle_customer(new_puzzle)

# helper function for process_drink and process_drink_for
func do_process_drink(drink: Drink, current_puzzle: Puzzle, customer: Customer = null) -> void:
	var result: Puzzle.Result = get_puzzle_evaluation(drink, current_puzzle)
	Dialogic.VAR.result = result
	var feedback: String = get_puzzle_feedback(drink, result, current_puzzle)
	Dialogic.VAR.feedback = feedback
	var gold_reward: int = get_puzzle_gold_reward(drink, result, current_puzzle)
	var result_names := ["Great Success", "Success", "Ehhh", "Failure"]
	
	gold_counter.text = str(int(gold_counter.text) + gold_reward)
	SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.GOLD_ADDED)
	#textbox.queue_text(current_puzzle.customer_name + ": " + feedback)
	Dialogic.VAR.ordering = false
	Dialogic.VAR.customer_name = get_current_puzzle().customer_name
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start('puzzle')
	get_viewport().set_input_as_handled()
	if(customer != null):
		SFX_Handler.trigger_sfx_func(SFX_Handler.SFX_Triggers.CUSTOMER_FEEDBACK, [customer, result], 1, .5, .25)
	#feedback_label.text = feedback

	print(result_names[result])
	print(feedback)
	print("Added gold: " + str(gold_reward))


func _show_customer_dialogue(customer: Customer):
	if DialogueHandler.current_state != DialogueHandler.State.READY:
		return
	
	print("Customer clicked: " + str(customer))
	var puzzle = get_current_puzzle()
	var order = puzzle.get_customer_and_order()
	textbox.queue_text(puzzle.customer_name + ": " + order)
	#order_label.text = order

func _customer_dialogue(customer: Customer):
	if Dialogic.current_timeline != null:
		return
	Dialogic.VAR.ordering = true
	var order = get_current_puzzle().get_customer_and_order()
	Dialogic.VAR.order = order
	Dialogic.VAR.customer_name = get_current_puzzle().customer_name
	Dialogic.start('puzzle')
	get_viewport().set_input_as_handled()

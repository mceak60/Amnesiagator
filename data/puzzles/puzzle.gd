class_name Puzzle
extends Node

# Consider as Abstract Class 
# GDscript does not currently implement these yet

enum Result {GREAT_SUCCESS, SUCCESS, EHHH, FAILURE}
const number_of_puzzles = 1

# SK 1/7/25 - Currently this is a bit of a mix of OOP and functional - further refactors could have the getters actually adjust the instance variables, instead of pulling them new each time :) 
 
#@export var result: Result
#@export var feedback: String
#@export var gold_reward: int

func check_customer(_customer: Customer) -> bool:
	assert(false, "Please override 'check_customer' in puzzle.")
	return false

func evaluate_drink(_drink: Drink) -> Result:
	assert(false, "Please override 'evaluate_drink' in puzzle.")
	return Result.FAILURE

func get_feedback(_drink: Drink, _result: Result) -> String:
	assert(false, "Please override 'get_feedback' in puzzle.")
	return "Error."
	
func get_gold_reward(_drink: Drink, _result: Result) -> int:
	assert(false, "Please override 'get_gold_reward' in puzzle.")
	return 0
	
	

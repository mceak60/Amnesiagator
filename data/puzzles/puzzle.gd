class_name Puzzle
extends Node

# Consider as Abstract Class 
# GDscript does not currently implement these yet

enum Result {GREAT_SUCCESS, SUCCESS, EHHH, FAILURE}
 
var customer_name: String
var customer_animal: String
var order: String
var result: Result
var feedback: String
var gold_reward: int

func get_customer_and_order() -> String:
	assert(false, "Please override 'get_order' in puzzle.")
	return order

func check_customer(_customer: Customer) -> bool:
	assert(false, "Please override 'check_customer' in puzzle.")
	return false

func evaluate_drink(_drink: Drink) -> Result:
	assert(false, "Please override 'evaluate_drink' in puzzle.")
	return result

func get_feedback(_drink: Drink, _result: Result) -> String:
	assert(false, "Please override 'get_feedback' in puzzle.")
	return feedback
	
func get_gold_reward(_drink: Drink, _result: Result) -> int:
	assert(false, "Please override 'get_gold_reward' in puzzle.")
	return gold_reward

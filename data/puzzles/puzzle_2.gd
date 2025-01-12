class_name Puzzle2
extends Puzzle

func get_customer_and_order() -> String:
	customer_name = "Mark"
	customer_animal = "Owl"
	order = "Hey Stu, I'm on a deadline. Don't have time to chit-chat. Give me a pick-me-up."
	return order

func check_customer(customer: Customer) -> bool:
	if customer.details.name == customer_name && customer.details.animal == customer_animal:
		return true
	return false

func evaluate_drink(drink: Drink) -> Result:
	var evaluated_result: Result
	if drink.attribute_list["Sleepy"] > 0:
		evaluated_result = Result.FAILURE
	
	elif drink.attribute_list["Electricity"] >= 1:
		if drink.attribute_list["Metallic"] >= 1:
			evaluated_result = Result.GREAT_SUCCESS
		else:
			evaluated_result = Result.SUCCESS
	
	else:
		evaluated_result = Result.EHHH
	
	result = evaluated_result
	return evaluated_result

func get_feedback(_drink: Drink, evaluated_result: Result) -> String:
	var evaluated_feedback: String
	match evaluated_result:
		Result.GREAT_SUCCESS:
			evaluated_feedback = "WHOA MAMA! You didn't hold back Stu, I feel the jolt right through my feathers! You bet your britches I'll be back tomorrow, gotta fly!"
		
		Result.SUCCESS:
			evaluated_feedback = "Mmmm, oh yeah, that's the stuff. Nice electric kick, but to be honest, your old stuff seemed stronger! Don't hold back on me next time, I can take it!"
		

		Result.EHHH:
			evaluated_feedback = "Hmm... I'm waiting... what's the big idea?! Where's the kick? I need something to shock me awake!"
		
		Result.FAILURE:
			evaluated_feedback = "*YAWN* ... What are you doing Stu, did you put sleeping pills in this? I asked for a pick-me-up, not a put-me-down! Should have just gone to a coffee shop..."
	
	feedback = evaluated_feedback
	return evaluated_feedback
	
func get_gold_reward(_drink: Drink, evaluated_result: Result) -> int:
	var evaluated_reward: int
	match evaluated_result:
		Result.GREAT_SUCCESS:
			evaluated_reward = 5
		Result.SUCCESS:
			evaluated_reward = 3
		Result.EHHH:
			evaluated_reward = 1
		Result.FAILURE:
			evaluated_reward = 0
	
	gold_reward = evaluated_reward
	return evaluated_reward

class_name Puzzle4
extends Puzzle

func get_customer_and_order() -> String:
	customer_name = "Father Cornelius"
	customer_animal = "Mink"
	order = "Good evening, my child. Something for your humble servant, if you would. As I say in my congregation, the mink shall inherit..."
	return order

func check_customer(customer: Customer) -> bool:
	if customer.details.name == customer_name && customer.details.animal == customer_animal:
		return true
	return false

func evaluate_drink(drink: Drink) -> Result:
	var evaluated_result: Result
	if drink.contains_n_from_attribute_list(3,["Earthy","Flora","Fruity"]):
		evaluated_result = Result.GREAT_SUCCESS
	
	elif drink.contains_n_from_attribute_list(2,["Earthy","Flora","Fruity"]):
		evaluated_result = Result.SUCCESS
		
	elif drink.contains_n_from_attribute_list(1,["Earthy","Flora","Fruity"]) || ["Ice","Bubbly Water"].any(drink.equals_sole_ingredient) || drink.has_ingredient("Stardust Sprinkles"):
		evaluated_result = Result.EHHH
	
	else:
		evaluated_result = Result.FAILURE
	
	result = evaluated_result
	return evaluated_result

func get_feedback(drink: Drink, evaluated_result: Result) -> String:
	var evaluated_feedback: String
	match evaluated_result:
		Result.GREAT_SUCCESS:
			evaluated_feedback = "Ah, blessed harmony! Like a forest chapel in spring. The earth, the blossoms, the fruits of creation... You truly understand the natural order, my child."
		
		Result.SUCCESS:
			if drink.contains_n_from_attribute_list(2,["Earthy","Flora"]):
				evaluated_feedback = "A blessed combination, though it yearns for the sweetness of the vine, much like our garden of contemplation."
			
			elif drink.contains_n_from_attribute_list(2,["Earthy","Fruity"]):
				evaluated_feedback = "The earthen foundation supports the fruit beautifully, though it lacks the grace of the blossom. Still, a worthy offering."

			else:
				evaluated_feedback = "A delightful blend of backyard pleasures, though it could something use more solid, to ground it, shall we say?"

		# SK 1/7/25 - Bug: for the ehhh feedback, a drink can have multiple attributes here - will need to disambiguate the "dominant" as currently this just takes the first one in the elif. 
		# To address in future
		Result.EHHH:
			if drink.contains_n_from_attribute_list(1,["Earthy","Flora","Fruity"]):
				evaluated_feedback = "The spirit is willing, but the blend is weak. Consider the whole of creation, not just a single facet."
			
			elif drink.equals_sole_ingredient("Bubbly Water"):
				evaluated_feedback = "My child, simplicity has its virtues, but perhaps we're being a bit too... ascetic?"
			
			elif drink.equals_sole_ingredient("Ice"):
				evaluated_feedback = "Do not test me, my child."

			elif drink.has_ingredient("Stardust Sprinkles"):
				evaluated_feedback = "Certainly a hint of the divine. But surely we can aim closer to our surroundings." 

			else:
				evaluated_feedback = "If god exists, he wouldn't speak this line of dialogue - test."
		
		Result.FAILURE:
			if drink.has_attribute("Heat"):
				evaluated_feedback = "Oh my! *cough* A bit too... infernal for my taste."
			
			elif drink.has_attribute("Cold"):
				evaluated_feedback = "I'm not an advocate of fire and brimstone, but that may help clear this brain freeze!" 

			elif drink.has_attribute("Electricity"):
				evaluated_feedback = "My child, cheap jolts are no substitute for natural revelation."
				
			elif drink.has_attribute("Metallic"):
				evaluated_feedback = "I seek communion with nature, not... industrial revolution."

			elif drink.has_attribute("Weird"):
				evaluated_feedback = "I appreciate modern expressions of faith, but perhaps something more... traditional?"

			else:
				evaluated_feedback = "This concoction demonstrates the virtue of abstinence. But fear not - the prodigal son always returns."
	
	feedback = evaluated_feedback
	return evaluated_feedback
	
func get_gold_reward(_drink: Drink, evaluated_result: Result) -> int:
	var evaluated_reward: int
	match evaluated_result:
		Result.GREAT_SUCCESS:
			evaluated_reward = 6
		Result.SUCCESS:
			evaluated_reward = 3
		Result.EHHH:
			evaluated_reward = 2
		Result.FAILURE:
			evaluated_reward = 1
	
	gold_reward = evaluated_reward
	return evaluated_reward

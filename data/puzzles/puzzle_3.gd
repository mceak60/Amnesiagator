class_name Puzzle3
extends Puzzle

func get_customer_and_order() -> String:
	customer_name = "Ziggy"
	customer_animal = "Chameleon"
	order = "Gimme the groove!"
	return order

func check_customer(customer: Customer) -> bool:
	if customer.details.name == customer_name && customer.details.animal == customer_animal:
		return true
	return false

func evaluate_drink(drink: Drink) -> Result:
	var evaluated_result: Result
	if drink.has_attribute("Earthy") || drink.has_attribute("Boring") || drink.num_total_ingredients() == 1:
		evaluated_result = Result.FAILURE
	
	elif drink.has_ingredient("Lava Lamp") && drink.has_ingredient("Stardust Sprinkles"):
		evaluated_result = Result.GREAT_SUCCESS
		
	elif drink.has_ingredient("Lava Lamp") || drink.has_ingredient("Stardust Sprinkles"):
		evaluated_result = Result.SUCCESS
	
	else:
		evaluated_result = Result.EHHH
	
	result = evaluated_result
	return evaluated_result

func get_feedback(drink: Drink, evaluated_result: Result) -> String:
	var evaluated_feedback: String
	match evaluated_result:
		Result.GREAT_SUCCESS:
			evaluated_feedback = "Far OUT! Now this is what I call cosmic! The colors, man... they're speaking to me! You're on my wavelength, bartender!"
		
		Result.SUCCESS:
			if drink.has_ingredient("Lava Lamp"):
				evaluated_feedback = "Almost there, daddy-o! The vibe is flowing, but it needs that extra shine, you dig?"
			
			elif drink.has_ingredient("Stardust Sprinkles"):
				evaluated_feedback = "Dig those sparkles! But it could use some more... smooth flow, if you catch my drift."
					
		# SK 1/7/25 - Bug: for the ehhh feedback, a drink can have multiple attributes here - will need to disambiguate the "dominant" as currently this just takes the first one in the elif. 
		# To address in future
		Result.EHHH:
			var priority_list = drink.get_attribute_priority_list()
			var option_1 = drink.get_priority_of(priority_list, "Metallic") + drink.get_priority_of(priority_list, "Electricity")
			var option_2 = drink.get_priority_of(priority_list, "Heat") + drink.get_priority_of(priority_list, "Cold")
			var option_3 = drink.get_priority_of(priority_list, "Fruity") + drink.get_priority_of(priority_list, "Flora")
			var option_4 = drink.get_priority_of(priority_list, "Electricity") + drink.get_priority_of(priority_list, "Fizzy")
			if option_1 == option_2 && option_2 == option_3 && option_3 == option_4:
				evaluated_feedback = "Huh... neat light show, but not quite groovy enough. Need something more... far out."
			else:
				match min(option_1, option_2, option_3, option_4):
					option_1:
				#if drink.has_attribute("Metallic") && drink.has_attribute("Electricity"):
						evaluated_feedback = "Whoa... cool chrome vibes, but I need something that flows with the cosmic waves."
					option_2:
				#elif drink.has_attribute("Heat") || drink.has_attribute("Cold"):
						evaluated_feedback = "Too elemental, man. I need to access another dimension!"
					option_3:
				#elif drink.has_attribute("Fruity") && drink.has_attribute("Flora"):
						evaluated_feedback = "A little too garden party, not enough space party, you know what I mean?"
					option_4:
				#elif drink.has_attribute("Electricity") && drink.has_attribute("Fizzy"):
						evaluated_feedback = "Dig the electricity, baby, but it's all fizz and no flow!"
		
		Result.FAILURE:
			if drink.has_attribute("Earthy"):
				evaluated_feedback = "What am I, some kind of tree hugger? I need something that'll make my scales dance!"
			
			else:
				evaluated_feedback = "...this is squaresville, baby. Where's the pizzazz? The movement? The GROOVE?"
	
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
			evaluated_reward = 2
		Result.FAILURE:
			evaluated_reward = 0
	
	gold_reward = evaluated_reward
	return evaluated_reward

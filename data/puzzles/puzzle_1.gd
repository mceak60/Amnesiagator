class_name Puzzle1
extends Puzzle

func evaluate_drink(drink: Drink) -> Result:
	var outcome: Result
	if drink.attribute_list["Heat"] > 0:
		outcome = Result.FAILURE
	
	elif drink.attribute_list["Cold"] == 1:
		outcome = Result.SUCCESS
	
	elif drink.attribute_list["Cold"] > 1:
		outcome = Result.GREAT_SUCCESS
	
	else:
		outcome = Result.EHHH
		
	return outcome

func get_feedback(drink: Drink, outcome: Result) -> String:
	var feedback: String
	match outcome:
		Result.GREAT_SUCCESS:
			feedback = "This is exactly what I needed - double the chill, double the thrill! You really know how to keep a penguin happy, Stu. Same time tomorrow?"
		
		Result.SUCCESS:
			feedback = "Not bad, not bad! Has that Arctic bite, though my usual's typically got an extra dose of polar power. But hey - I'm not complaining!"
		
		# SK 1/7/25 - Bug: for the ehhh feedback, a drink can have multiple attributes here - will need to disambiguate the "dominant" as currently this just takes the first one in the elif. 
		# To address in future
		Result.EHHH:
			if drink.attribute_list["Fizzy"] > 0 || drink.attribute_list["Electricity"] > 0:
				feedback = "Wow, that's... different! But my usual's more chill, if you catch my drift."
			
			elif drink.get_ingredient_names().has("Lava Lamp") && drink.get_ingredient_names().has("Stardust Sprinkles"):
				feedback = "Ooh, pretty! Like the Southern Lights! But I usually prefer something that reminds me more of home."
			
			elif (drink.get_ingredient_names().has("Berry Brew") && drink.get_ingredient_names().has("Blossom Petals")) || (drink.get_ingredient_names().has("Berry Brew") && drink.get_ingredient_names().has("Hickory")):
				feedback = "Fancy! But I'm more of a ‘simple pleasures’ kind of guy."
			
			else:
				feedback = "Welp... it's not bad, but something's missing. Not exactly what I usually get, but at least it didn't melt my beak off!"
		
		Result.FAILURE:
			if drink.get_ingredient_names().has("Fireball Whiskey") && drink.get_ingredient_names().has("Red Pepper Flakes"):
				feedback = "Sweet frozen fish sticks! Did you mistake me for a dragon?! I'll... uh... come back tomorrow. Maybe try something more polar-friendly next time?"
			
			elif drink.get_ingredient_names().has("Fireball Whiskey"):
				feedback = "SQUAWK! What in the Emperor's name-- Stu! My usual is supposed to remind me of home, not turn me into a puddle!"
			
			elif drink.get_ingredient_names().has("Red Pepper Flakes"):
				feedback = "ACK! Not even my grandfather’s feathers could handle this spice! Time to go stick my head in a snowbank..."
			
			else:
				feedback = "Too hot!"
				#this is to catch if we add more "hot" ingredients that would not be caught by the other cases
				#either "Solly-fy" this and leave it in, or delete it if no other hot ingredients get added
	
	return feedback
	
func get_gold_reward(_drink: Drink, result: Result) -> int:
	var reward: int
	match result:
		Result.GREAT_SUCCESS:
			reward = 5		
		Result.SUCCESS:
			reward = 3		
		Result.EHHH:
			reward = 1
		Result.FAILURE:
			reward = 0
	
	return reward
	

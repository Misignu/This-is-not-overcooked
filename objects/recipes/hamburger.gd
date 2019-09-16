extends Sprite

export var price: int = 100 setget, get_price

func add_ingredient(ingredient: Ingredient) -> bool: # TODO REFACTOR -> Código gambiarroso
	var current_frame = frame
	
	if frame == 0:
		print('try to add [ ', ingredient.name, "] to bread")
		
		if "Meat" in ingredient.name:
			frame = 1
			
		elif "Lettuce" in ingredient.name:
			frame = 2
		
	elif frame == 1:
		print('try to add [', ingredient.name, "] to sandwish")
		
		if "Lettuce" in ingredient.name:
			frame = 3
		
	elif frame == 2:
		print('try to add [', ingredient.name, "] to vegan sandwish")
		
		if "Meat" in ingredient.name:
			frame = 3
	
	return current_frame != frame

func get_price() -> int:
	
	return price
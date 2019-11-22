extends Sprite
"""
@notes
	ingredients é um array que localiza o frame da receita conforme as coordenadas do frame atual e o nome do ingredient sendo inserido
"""
export var price: int = 100 setget, get_price
export var ingredients: PoolStringArray = [
	"IngredientName"
]
export(Array) var steps := [ # O valor armazenado aqui serve de placeholder para facilitar o entendimento da estrutura desses dados
	[ # x = 0 <- Valor do frame atual sendo 'x'
		{ # y = 0 <- Valor do frame atual sendo 'y'
			ingredients[0]: 1 # <- Se o nome do ingredient que deseja adicionar na receita for igual a IngredientName, o frame atual será 'X' (nesse caso 1)
		}
	],
	[
		{
			ingredients[0]: 2
		}
	]
]

func add_ingredient(ingredient: Ingredient) -> bool:
	var current_frame = frame
	
	for ingredient_name in steps[frame_coords.x][frame_coords.y]:

		if ingredient_name in ingredient.name:
			print()
			frame = steps[frame_coords.x][frame_coords.y][ingredient_name]
			break
	
	return current_frame != frame

func get_price() -> int:
	
	return price

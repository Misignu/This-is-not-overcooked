extends Sprite
"""
@notes
	ingredients é um array que localiza o frame da receita conforme as coordenadas do frame atual e o nome do ingredient sendo inserido
"""
export var price: int = 100 setget, get_price
export(Array) var ingredients := [ # O valor armazenado aqui serve de placeholder para facilitar o entendimento da estrutura desses dados
	[ # x = 0 <- Valor do frame atual sendo 'x'
		{ # y = 0 <- Valor do frame atual sendo 'y'
			"IngredientName": 1 # <- Se o nome do ingredient que deseja adicionar na receita for igual a IngredientName, o frame atual será 'X' (nesse caso 1)
		}
	],
	[
		{
			"IngredientName": 2
		}
	]
]

func add_ingredient(ingredient: Ingredient) -> bool:
	var current_frame = frame
	
	for ingredient_name in ingredients[frame_coords.x][frame_coords.y]:

		if ingredient_name in ingredient.name:
			print()
			frame = ingredients[frame_coords.x][frame_coords.y][ingredient_name]
			break
	
	return current_frame != frame

func get_price() -> int:
	
	return price

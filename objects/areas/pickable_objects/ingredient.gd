extends PickableObject
class_name Ingredient

"""
Igredients possuem uma série de tipos de preparo. Seus métodos reduzem esses tipos, conforme são ultilizados.

	Um Igredient possui uma série de preparation_type's que determina seu estado, e métodos que modificam esse estado.
	O método prepare é responsável por lidar com chamadas externas pelo objeto que contém uma referência ao igrediente.

@notes
	Evite alterar preparation_type externamente, NUNCA insira um valor negativo.
	Sempre use as constantes (que determinam estado) no padrão Bitflag.
	
	O tempo de preparo afeta o tempo de execução das ações que se pode fazer com o ingrediente. Verique set_preparation_state()
	O tempo de corte (CUTTIME) é fixo, portanto não é afetado.
	O tempo de fritura será o tempo de preparo vezes um modificador (FRY_TIME_MODIFIER).
	O tempo de cozimento é igual ao tempo de preparo (preparation_time) sem modificações.
"""
const CUTTABLE = 1
const FRIABLE = 2
const COOKABLE = 4
export(int, FLAGS, "cuttable", "friable", "cookable") var preparation_type  # TODO op -> Implementar cook. Como esse é um protótipo não há necessidade

const CUT_TIME = 3.0
export(float, 1.0, 60.0, .5) var preparation_time: float = 2.0

export(Texture) var ingredient_label: Texture setget, get_ingredient_label
export(Texture) var cutted_sprite: Texture setget, get_cutted_sprite
export(Texture) var fried_frames: Texture setget, get_fried_frames
export(Texture) var cooked_sprite: Texture setget, get_cooked_sprite

var is_burned: bool = false
var preparation_state: int setget set_preparation_state

onready var fry_time = preparation_time * .5
onready var preparation_timer_wait_time: float = preparation_time setget, get_preparation_timer_wait_time

func _ready():
	set_preparation_state()

func prepare(action: String, timer: Timer) -> void:
	
	assert(timer.connect("timeout", self, str("_on_PreparationTimer_", action, "_timeout"), [timer]) == OK)
	timer.start(preparation_timer_wait_time)

func stop(action, timer: Timer) -> void:
	
	preparation_timer_wait_time = timer.time_left
	timer.disconnect("timeout", self, str("_on_PreparationTimer_", action, "_timeout"))
	timer.stop()

# @signals
func _on_PreparationTimer_cut_timeout(timer: Timer) -> void:
	
	preparation_type -= CUTTABLE
	set_preparation_state()
	_change_ingridient_sprite("cutted_sprite")
	timer.disconnect("timeout", self, "_on_PreparationTimer_cut_timeout")

func _on_PreparationTimer_fry_timeout(timer: Timer) -> void:
	
	preparation_type -= FRIABLE
	set_preparation_state()
	_change_ingridient_sprite("fried_frames")
	timer.disconnect("timeout", self, "_on_PreparationTimer_fry_timeout")

func _change_ingridient_sprite(type: String) -> void:
	
	if get(type) != null:
		
		if type == "fried_frames":
			$Sprite.hframes = 3
			
		else:
			$Sprite.hframes = 1
		
		$Sprite.texture = get(type)
		
	else:
		
		push_warning(str("None texture defined to ", type, " in ", name))

func _on_BurnTimer_timeout():
	is_burned = true

# @setters
func set_preparation_state(type: int = preparation_type) -> void:
	
	if bool(type & CUTTABLE):
		
		preparation_state = CUTTABLE
		preparation_timer_wait_time = CUT_TIME
		
	elif bool(type & FRIABLE):
		
		preparation_state = FRIABLE
		preparation_timer_wait_time = fry_time
		
	elif bool(type & COOKABLE):
		
		preparation_state = COOKABLE
		preparation_timer_wait_time = preparation_time
		
	else:
		
		preparation_state = 0
		preparation_timer_wait_time = 0

# @getters
func get_preparation_timer_wait_time() -> float:
	return preparation_timer_wait_time

func get_ingredient_label() -> Texture:
	return ingredient_label

func get_cutted_sprite() -> Texture:
	return cutted_sprite

func get_fried_frames() -> Texture:
	return fried_frames

func get_cooked_sprite() -> Texture:
	return cooked_sprite


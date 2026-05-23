extends Resource
class_name PotionPile

signal potion_pile_size_changed(potion_amount: int)

@export var potions: Array[Potion] = []

func is_empty() -> bool:
	return potions.is_empty()

func draw_potion() -> Potion:
	var ret: Potion = potions.pop_front()
	potion_pile_size_changed.emit(potions.size())
	return ret

func add_potion(potion: Potion) -> void:
	potions.append(potion)
	potion_pile_size_changed.emit(potions.size())

func add_potion_to_top(potion: Potion) -> void:
	potions.insert(0, potion)
	potion_pile_size_changed.emit(potions.size())

func remove_potion(potion: Potion) -> void:
	var idx = potions.find(potion)
	if idx != -1:
		potions.remove_at(idx)
		potion_pile_size_changed.emit(potions.size())

func shuffle() -> void:
	potions.shuffle()

func clear() -> void:
	potions.clear()
	potion_pile_size_changed.emit(0)

func _to_string() -> String:
	var potion_strings: PackedStringArray = []
	for i in range(potions.size()):
		potion_strings.append("%s: %s" % [i + 1, potions[i].id])  # 假设 Potion 有 id 属性
	return "\n".join(potion_strings)

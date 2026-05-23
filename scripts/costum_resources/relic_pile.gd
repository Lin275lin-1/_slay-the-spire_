extends Resource
class_name RelicPile

signal relic_pile_size_changed(relic_amount: int)

@export var relics: Array[Relic] = []

func is_empty() -> bool:
	return relics.is_empty()

func draw_relic() -> Relic:
	var ret: Relic = relics.pop_front()
	relic_pile_size_changed.emit(relics.size())
	return ret

func add_relic(relic: Relic) -> void:
	relics.append(relic)
	relic_pile_size_changed.emit(relics.size())

func add_relic_to_top(relic: Relic) -> void:
	relics.insert(0, relic)
	relic_pile_size_changed.emit(relics.size())

func remove_relic(relic: Relic) -> void:
	var idx = relics.find(relic)
	if idx != -1:
		relics.remove_at(idx)
		relic_pile_size_changed.emit(relics.size())

func shuffle() -> void:
	relics.shuffle()

func clear() -> void:
	relics.clear()
	relic_pile_size_changed.emit(0)

func _to_string() -> String:
	var relic_strings: PackedStringArray = []
	for i in range(relics.size()):
		relic_strings.append("%s: %s" % [i + 1, relics[i].relic_name])
	return "\n".join(relic_strings)

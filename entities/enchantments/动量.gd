extends Enchantment

var played_times := 0

func _init() -> void:
	Events.combat_won.connect(func(_context: RewardContext): played_times = 0)

func get_modifiers() -> Array[Modifier]:
	return [Modifier.new(Enums.NumericType.DAMAGE, played_times * stacks, 1.0, null)]

func on_play(_player: Player, _targets: Array[Node]) -> void:
	played_times += 1

func get_description() -> String:
	return description.format({"stacks": stacks})

func can_enchant(card: Card) -> bool:
	if card.has_enchantment():
		return false
	return card.has_attack_effect()

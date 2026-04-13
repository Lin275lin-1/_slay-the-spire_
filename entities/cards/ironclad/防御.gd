extends Card
	
func apply_effects(source: Player, targets: Array[Node]) -> void:
	var numeric_entries = get_numeric_entries()
	var block_effect := BlockEffect.new()
	block_effect.sound = sound
	block_effect.execute(GainBlockContext.new(source, targets, get_numeric_value(numeric_entries[0]), get_enchantment_modifiers(numeric_entries[0])))

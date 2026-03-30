extends Card
	
func apply_effects(source: Player, targets: Array[Node]) -> void:
	var block_effect := BlockEffect.new()
	block_effect.sound = sound
	block_effect.execute(GainBlockContext.new(source, targets, get_numeric_value(get_numeric_entries(), 0)))

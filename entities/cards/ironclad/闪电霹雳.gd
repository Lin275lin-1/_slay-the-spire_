extends Card
	
func apply_effects(source: Player, targets: Array[Node]) -> void:
	var numeric_entries = get_numeric_entries()
	var attack_effect := AttackEffect.new()
	attack_effect.sound = sound
	attack_effect.execute(DamageContext.new(source, targets, get_numeric_value(numeric_entries[0]), get_enchantment_modifiers(numeric_entries[0])))
	var buff_effect := ApplyBuffEffect.new()
	buff_effect.execute(ApplyBuffContext.new(source, targets, get_numeric_value(numeric_entries[1]), VulnerableDebuff.new()))

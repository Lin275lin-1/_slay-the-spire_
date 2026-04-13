extends Card

	
func apply_effects(source: Player, targets: Array[Node]) -> void:
	var numeric_entries := get_numeric_entries()
	var attack_effect := AttackEffect.new()
	attack_effect.sound = sound
	var damage_context := DamageContext.new(source, targets, \
	get_numeric_value(numeric_entries[0], source), get_enchantment_modifiers(numeric_entries[0]))
	attack_effect.execute(damage_context)

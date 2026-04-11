extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var attack_effect := AttackEffect.new()
	attack_effect.sound = sound
	attack_effect.execute(DamageContext.new(source, targets, get_numeric_value(get_numeric_entries(), 0)))

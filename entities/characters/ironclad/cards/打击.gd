extends Card

#func apply_effects(context: Context) -> void:
	
func apply_effects(source: Player, targets: Array[Node]) -> void:
	var damage_effect := AttackEffect.new()
	damage_effect.sound = sound
	damage_effect.execute(DamageContext.new(source, targets, get_numeric_value(get_numeric_entries(), 0)))
	

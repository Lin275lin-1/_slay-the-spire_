extends Card

#func apply_effects(context: Context) -> void:
	

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var attack_effect := AttackEffect.new()
	var lose_health_effect := LossHealthEffect.new()
	attack_effect.sound = sound
	var lose_health_context = LoseHealthContext.new(source, [source], 1)
	var	damage_context = DamageContext.new(source, targets, get_numeric_value(get_numeric_entries(), 0))
	lose_health_effect.execute(lose_health_context)
	attack_effect.execute(damage_context)

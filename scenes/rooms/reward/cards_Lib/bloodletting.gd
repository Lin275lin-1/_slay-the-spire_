extends Card

func apply_effects(context: Context) -> void:
	# 失去3点生命
	var lose_health_effect := LossHealthEffect.new()
	var lose_health_context = LoseHealthContext.new(context.source, [context.source], 3)
	lose_health_effect.sound = sound
	lose_health_effect.execute(lose_health_context)
	
	# 获得2点能量
	#var gain_energy_effect := GainEnergyEffect.new()
	#gain_energy_effect.execute(GainEnergyContext.new(context.source, 2))

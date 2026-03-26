extends Card

func apply_effects(context: Context) -> void:
	# 造成6点伤害
	var attack_effect := AttackEffect.new()
	context.amount = 6
	attack_effect.sound = sound
	attack_effect.execute(context)
	
	# 如果敌人有虚弱，获得5点格挡
	if context.targets[0].has_buff("虚弱"):
		var block_effect := BlockEffect.new()
		context.amount = 5
		block_effect.sound = sound
		block_effect.execute(context)

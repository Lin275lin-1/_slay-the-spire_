extends Card

func apply_effects(context: Context) -> void:
	# 造成8点伤害
	var attack_effect := AttackEffect.new()
	context.amount = 8
	attack_effect.sound = sound
	attack_effect.execute(context)
	
	# 如果目标有易伤，获得8点格挡
	if context.targets[0].has_buff("易伤"):
		var block_effect := BlockEffect.new()
		context.amount = 8
		block_effect.sound = sound
		block_effect.execute(context)

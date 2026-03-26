extends Card

func apply_effects(context: Context) -> void:
	# 获得12点格挡
	var block_effect := BlockEffect.new()
	context.amount = 12
	block_effect.sound = sound
	block_effect.execute(context)
	
	# 施加反弹4点伤害的Buff（荆棘）
	var thorns_effect := ApplyBuffEffect.new()
	thorns_effect.execute(ApplyBuffContext.new(context.source, [context.source], 4, ThornsBuff.new()))

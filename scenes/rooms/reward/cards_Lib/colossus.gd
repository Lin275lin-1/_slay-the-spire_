extends Card

func apply_effects(context: Context) -> void:
	# 获得3点力量
	var strength_effect := ApplyBuffEffect.new()
	strength_effect.sound = sound
	strength_effect.execute(ApplyBuffContext.new(context.source, [context.source], 3, StrengthBuff.new()))
	# 每回合失去1点力量（通过施加一个持续减益Buff实现）
	var decay_effect := ApplyBuffEffect.new()
	#decay_effect.execute(ApplyBuffContext.new(context.source, [context.source], 1, StrengthDecayBuff.new()))

extends Card

func apply_effects(context: Context) -> void:
	# 被动效果：每消耗一张牌获得3点格挡（通过Buff实现）
	var buff_effect := ApplyBuffEffect.new()
	buff_effect.sound = sound
	#buff_effect.execute(ApplyBuffContext.new(context.source, [context.source], 1, FeelNoPainBuff.new()))

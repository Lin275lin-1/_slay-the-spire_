extends Card

func apply_effects(context: Context) -> void:
	# 造成5点伤害
	var attack_effect := AttackEffect.new()
	context.amount = 5
	attack_effect.sound = sound
	attack_effect.execute(context)
	
	# 施加1层虚弱
	var weak_effect := ApplyBuffEffect.new()
	#weak_effect.execute(ApplyBuffContext.new(context.source, context.targets, 1, WeakBuff.new()))
	#
	# 抽1张牌
	#var draw_effect = DrawEffect.new()
	#draw_effect.execute(DrawContext.new(context.source, 1))

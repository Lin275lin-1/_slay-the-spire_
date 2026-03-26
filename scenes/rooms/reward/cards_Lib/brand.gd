extends Card

func apply_effects(context: Context) -> void:
	# 造成7点伤害
	var attack_effect := AttackEffect.new()
	context.amount = 7
	attack_effect.sound = sound
	attack_effect.execute(context)
	
	# 施加2层虚弱
	var buff_effect := ApplyBuffEffect.new()
	#buff_effect.execute(ApplyBuffContext.new(context.source, context.targets, 2, WeakBuff.new()))

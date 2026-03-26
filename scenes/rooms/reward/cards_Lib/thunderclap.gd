extends Card

func apply_effects(context: Context) -> void:
	# 对所有敌人造成4点伤害
	var attack_effect := AttackEffect.new()
	context.amount = 4
	attack_effect.sound = sound

	#attack_effect.execute(context, true)  # true表示全体
	
	# 对所有敌人施加1层易伤
	var buff_effect := ApplyBuffEffect.new()
	buff_effect.execute(ApplyBuffContext.new(context.source, context.targets, 1, VulnerableDebuff.new()))

extends Card

func apply_effects(context: Context) -> void:
	# 造成5点伤害
	var damage = 5
	# 如果目标有格挡，额外造成5点伤害
	if context.targets[0].get_block() > 0:
		damage += 5
	var attack_effect := AttackEffect.new()
	context.amount = damage
	attack_effect.sound = sound
	attack_effect.execute(context)

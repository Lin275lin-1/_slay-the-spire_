extends Card

func apply_effects(context: Context) -> void:
	# 造成6点伤害，随机再造成一次同等伤害
	var attack_effect := AttackEffect.new()
	context.amount = 6
	attack_effect.sound = sound
	attack_effect.execute(context)
	# 随机再造成一次（简单实现：再执行一次相同效果）
	attack_effect.execute(context)

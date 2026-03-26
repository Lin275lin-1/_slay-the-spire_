extends Card

func apply_effects(context: Context) -> void:
	# 造成32点伤害
	var attack_effect := AttackEffect.new()
	context.amount = 32
	attack_effect.sound = sound
	attack_effect.execute(context)

extends Card

func apply_effects(context: Context) -> void:
	# 造成等同于当前格挡值的伤害
	var block = context.source.get_block()
	var attack_effect := AttackEffect.new()
	context.amount = block
	attack_effect.sound = sound
	attack_effect.execute(context)

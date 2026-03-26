extends Card

func apply_effects(context: Context) -> void:
	# 获得15点格挡
	var block_effect := BlockEffect.new()
	context.amount = 15
	block_effect.sound = sound
	block_effect.execute(context)

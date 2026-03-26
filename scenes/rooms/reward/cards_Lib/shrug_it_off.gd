extends Card

func apply_effects(context: Context) -> void:
	# 获得8点格挡
	var block_effect := BlockEffect.new()
	context.amount = 8
	block_effect.sound = sound
	block_effect.execute(context)
	
	# 抽1张牌
	#var draw_effect = DrawEffect.new()
	#draw_effect.execute(DrawContext.new(context.source, 1))

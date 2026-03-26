extends Card

func apply_effects(context: Context) -> void:
	# 消耗1张牌，抽2张牌
	pass
	# 具体实现依赖游戏手牌选择逻辑，此处仅作框架
	# 示例：消耗当前选中的手牌（需配合UI选择）
	#var consume_effect = ConsumeCardEffect.new()
	#consume_effect.execute(ConsumeContext.new(context.source, 1))
	#var draw_effect = DrawEffect.new()
	#draw_effect.execute(DrawContext.new(context.source, 2))

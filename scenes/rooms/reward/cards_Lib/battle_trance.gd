extends Card

func apply_effects(context: Context) -> void:
	pass
	# 抽3张牌
	#var draw_effect = DrawEffect.new()
	#draw_effect.execute(DrawContext.new(context.source, 3))
	## 本回合不能再抽牌（通过施加一个“不能抽牌”的Buff实现）
	#var buff_effect := ApplyBuffEffect.new()
	#buff_effect.execute(ApplyBuffContext.new(context.source, [context.source], 1, NoDrawBuff.new()))

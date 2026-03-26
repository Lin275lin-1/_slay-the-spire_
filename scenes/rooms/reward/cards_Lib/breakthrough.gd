extends Card

func apply_effects(context: Context) -> void:
	# 力量翻倍
	var current_strength = context.source.get_strength()
	var new_strength = current_strength * 2
	var buff_effect := ApplyBuffEffect.new()
	buff_effect.sound = sound
	buff_effect.execute(ApplyBuffContext.new(context.source, [context.source], new_strength, StrengthBuff.new()))
	# 消耗（exhaust）属性已在卡牌资源中标记，无需额外处理

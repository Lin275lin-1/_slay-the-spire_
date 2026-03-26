extends Card

func apply_effects(context: Context) -> void:
	# 施加“壁垒”效果（格挡不会消失）
	var buff_effect := ApplyBuffEffect.new()
	buff_effect.sound = sound
	#buff_effect.execute(ApplyBuffContext.new(context.source, [context.source], 1, BarricadeBuff.new()))

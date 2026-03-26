extends Card

func apply_effects(context: Context) -> void:
	var apply_buff_effect := ApplyBuffEffect.new()
	apply_buff_effect.execute(ApplyBuffContext.new(context.source, \
	[context.source], 2, StrengthBuff.new()))
	apply_buff_effect.sound = sound
	apply_buff_effect.execute(ApplyBuffContext.new(context.source,\
	[context.source], 2, DemonFormBuff.new()))

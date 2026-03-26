extends Card

func apply_effects(context: Context) -> void:
	var apply_buff_effect := ApplyBuffEffect.new()
	apply_buff_effect.sound = sound
	# 施加1层易伤
	apply_buff_effect.execute(ApplyBuffContext.new(context.source, \
	context.targets, 1, VulnerableDebuff.new()))
	# 获取目标易伤层数
	var buff_node: Buff = context.targets[0].get_buff("易伤")
	if not buff_node:
		return
	# 根据层数给自己加力量
	apply_buff_effect.execute(ApplyBuffContext.new(context.source, \
	[context.source], buff_node.stacks, StrengthBuff.new()))

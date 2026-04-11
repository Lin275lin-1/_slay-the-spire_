extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var apply_buff_effect := ApplyBuffEffect.new()
	apply_buff_effect.execute(ApplyBuffContext.new(source, \
	targets, get_numeric_value(get_numeric_entries(), 0), VulnerableDebuff.new()))
	# 该卡牌为单目标
	var buff_node: Buff = targets[0].get_buff("易伤")
	if not buff_node:
		return 
	apply_buff_effect.execute(ApplyBuffContext.new(source,\
	[source], buff_node.stacks, StrengthBuff.new()))

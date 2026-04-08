extends Card

func apply_effects(player: Player, targets: Array[Node]) -> void:
	# 获得3点力量（施加给玩家自己）
	var strength_effect := ApplyBuffEffect.new()
	strength_effect.sound = sound
	# 构造一个 ApplyBuffContext，目标为玩家
	var buff_context = ApplyBuffContext.new(player, [player], 3, StrengthBuff.new())
	strength_effect.execute(buff_context)
	
	# 每回合失去1点力量（施加一个持续减益Buff，例如 StrengthDecayBuff）
	var decay_effect := ApplyBuffEffect.new()
	# decay_effect.execute(ApplyBuffContext.new(player, [player], 1, StrengthDecayBuff.new()))

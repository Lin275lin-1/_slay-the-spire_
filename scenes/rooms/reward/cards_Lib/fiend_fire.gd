extends Card

func apply_effects(context: Context) -> void:
	# 消耗手牌，每张造成7点伤害
	var hand = context.source.get_hand()
	var damage = hand.size() * 7
	# 消耗所有手牌（需实现消耗逻辑）
	#var consume_effect = ConsumeAllHandEffect.new()
	#consume_effect.execute(ConsumeContext.new(context.source))
	# 造成总伤害
	var attack_effect := AttackEffect.new()
	context.amount = damage
	attack_effect.sound = sound
	attack_effect.execute(context)

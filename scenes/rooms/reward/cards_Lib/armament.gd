extends Card

func apply_effects(context: Context) -> void:
	# 获得5点格挡
	var block_effect := BlockEffect.new()
	context.amount = 5
	block_effect.sound = sound
	block_effect.execute(context)
	
	# 升级手牌中一张牌（需要在游戏逻辑中实现，这里留空）

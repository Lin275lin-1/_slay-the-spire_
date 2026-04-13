class_name ResolutionEntry
extends Object
# 要结算的卡牌
var card: Card
# 上下文
var context: Context
# 当前执行到第n个效果
var effect_index: int = 0

func is_finished() -> bool:
	return effect_index >= card.effects.size()

func get_current_effect() -> Effect:
	return card.effects[effect_index]

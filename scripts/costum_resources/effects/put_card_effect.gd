class_name PutCardEffect
extends Effect

# 没有使用

func execute(context: Context) -> Variant:
	for target: Creature in context.targets:
		if not target:
			continue
		if target is Player:
			var put_card_context = (context as PutCardContext)
			match context.where:
				# 抽牌堆
				0:
					for i in range(context.amount):
						target.put_card_in_draw_pile(put_card_context.card.duplicate())
				# 弃牌堆
				1:
					for i in range(context.amount):
						target.put_card_in_discard_pile(put_card_context.card.duplicate())
				# 手牌
				2:
					for i in range(context.amount):
						target.put_card_in_hand(put_card_context.card.duplicate())
				
	return null

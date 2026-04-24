class_name PutCardToPileEffect
extends CardEffect

#return func(card: Card):
				#if where == Where.DISCARD_PILE:
					#source.stats.discard_pile.remove_card(card)
				#elif where == Where.HAND:
					#source.remove_card_in_hand(card)
				#source.stats.draw_pile.add_card_to_top(card)
enum TargetPile{
	DrawPile,
	DiscardPile,
	HAND
}

@export var target_pile: TargetPile = TargetPile.DrawPile
# 是否放在牌库顶，如果否，在加入卡牌后会随机洗牌
@export var top: bool = true

func _init(target_pile_: TargetPile = TargetPile.DrawPile, top_: bool = true) -> void:
	target_pile = target_pile_
	top = top_
				
func execute(source: Node, card_context: Dictionary = {}, _previous_result: Variant = null) -> Variant:
	var card = card_context.get("target_card", null)
	var source_pile = card_context.get("source_pile", -1)
	source = (source as Player)
	if !(card is Card):
		return 0
	match source_pile:
		SelectCardEffect.Where.HAND:
			source.remove_card_in_hand(card)
		SelectCardEffect.Where.DRAW_PILE:
			source.remove_card_in_draw_pile(card)
		SelectCardEffect.Where.DISCARD_PILE:
			source.remove_card_in_discard_pile(card)
	match target_pile:
		TargetPile.DrawPile:
			source.put_card_in_draw_pile(card, top)
			return 1
		TargetPile.DiscardPile:
			source.put_card_in_discard_pile(card)
			return 1
		TargetPile.HAND:
			source.put_card_in_hand(card)
			return 1
	return 0

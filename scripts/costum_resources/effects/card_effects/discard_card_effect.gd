class_name DiscardCardEffect
extends CardEffect

func execute(source: Node, card_context: Dictionary = {}, _previous_result: Variant = null) -> Variant:
	var card = card_context.get("target_card", null)
	var source_pile = card_context.get("source_pile", -1)
	if !(card is Card):
		return 0
	if source_pile == SelectCardEffect.Where.HAND:
		(source as Player).discard_card(card)
		return 1
	return 0

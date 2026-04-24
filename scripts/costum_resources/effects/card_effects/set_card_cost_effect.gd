class_name SetCardCostEffect
extends CardEffect

@export var delta: int = 0

func execute(source: Node, card_context: Dictionary = {}, _previous_result: Variant = null) -> Variant:
	var card = (card_context.get("target_card", null) as Card)
	source = (source as Player)
	if card:
		card.base_cost = max(0, card.base_cost + delta)
		card.upgraded_cost = max(0, card.upgraded_cost + delta) 
		if card_context.get("source_pile", null) == SelectCardEffect.Where.HAND:
			source.agent.update_hand()
	return null

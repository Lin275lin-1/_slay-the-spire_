extends Card
	
func apply_effects(source: Player, targets: Array[Node]) -> void:
	var choose_card_effect = ChooseHandCardEffect.new()
	var target_cards: Array[Card] = source.get_hand_cards()
	target_cards.erase(self)
	await choose_card_effect.execute(ChooseCardContext.new(source, target_cards, "选择一张卡牌消耗", 1, 1, func(card: Card): source.exhaust_hand_card(card)))
	await source.draw_cards(DrawCardContext.new(source, targets, get_numeric_value(get_numeric_entries()[0])))

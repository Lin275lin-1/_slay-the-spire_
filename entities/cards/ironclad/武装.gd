extends Card

#func apply_effects(context: Context) -> void:
	

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var numeric_entries := get_numeric_entries()
	var block_effect := BlockEffect.new()
	block_effect.sound = sound
	block_effect.execute(GainBlockContext.new(source, targets, get_numeric_value(numeric_entries[0]), get_enchantment_modifiers(numeric_entries[0])))
	var choose_card_effect := ChooseHandCardEffect.new()
	var target_cards: Array[Card] = []
	for card: Card in source.get_hand_cards():
		if not card.upgraded:
			target_cards.append(card)
	target_cards.erase(self)
	if upgraded:
		choose_card_effect.execute(ChooseCardContext.new(source, target_cards, "选择一张手牌升级", 10, 10, func(card: Card): card.upgrade()))
	else:
		choose_card_effect.execute(ChooseCardContext.new(source, target_cards, "选择一张手牌升级", 1, 1, func(card: Card): card.upgrade()))

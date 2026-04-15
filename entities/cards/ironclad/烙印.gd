extends Card

#func apply_effects(context: Context) -> void:
	

#func apply_effects(source: Player, targets: Array[Node]) -> void:
	#var numeric_entries: Array[NumericEntry] = get_numeric_entries()
	#var lose_health_effect = LossHealthEffect.new()
	#var apply_buff_effect = ApplyBuffEffect.new()
	#var choose_card_effect = ChooseHandCardEffect.new()
	#lose_health_effect.execute(LoseHealthContext.new(source, targets, 1))
	#apply_buff_effect.execute(ApplyBuffContext.new(source, targets, get_numeric_value(numeric_entries[0]), StrengthBuff.new()))
	#var target_cards: Array[Card]
	#for card: Card in source.get_hand_cards():
		#if not card.ethereal:
			#target_cards.append(card)
	#target_cards.erase(self)
	#choose_card_effect.execute(ChooseCardContext.new(source, target_cards, "选择一张卡牌消耗", 1, 1, func(card: Card): source.exhaust_hand_card(card)))
	#

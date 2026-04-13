# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var numeric_entries := get_numeric_entries()
	var damage_effect := AttackEffect.new()
	damage_effect.sound = sound
	damage_effect.execute(DamageContext.new(source, targets, get_numeric_value(numeric_entries[0]), get_enchantment_modifiers(numeric_entries[0])))
	var choose_card_effect := ChooseDeckCardEffect.new()
	var target_cards = source.stats.get_discard_pile()
	#target_cards.erase(self)
	choose_card_effect.execute(ChooseCardContext.new(source, target_cards, "选择一张牌加入抽牌堆顶", 1, 1, 
	func(card: Card):
		source.stats.discard_pile.remove_card(card)
		source.stats.draw_pile.add_card_to_top(card)
		))

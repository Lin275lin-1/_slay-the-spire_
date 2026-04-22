class_name ChooseCardEffect
extends Effect

enum Where{
	DRAW_PILE,
	HAND,
	DISCARD_PILE,
}

enum Callback{
	UPGRADE,
	EXHAUST,
	APPLY_EXHAUST,
	APPLY_ETHEREAL,
	APPLY_SLY,
	PUT_INTO_DRAW_PILE_TOP,
	DISCARD,
	FREE_FOR_COMBAT, # 本场战斗免费打出
	PUT_INTO_HAND,
	PUT_INTO_HAND_AND_FIRST_PLAY_FREE # 应该重构的但是我懒得改了
}

enum RandomChooseMode{
	NONE, # 手动选择
	ALL, # 自动选择所有卡牌
	ATTACK, # 自动选择所有攻击牌
	NON_ATTACK, # 自动选择所有非攻击牌
	RANDOM, # 随机选择
	FIRST, # 第一张
}

@export var callback: Callback
@export var where: Where
@export var min_select: int
@export var max_select: int
@export var random_choose_mode: RandomChooseMode

func apply(source: Node, _targets: Array[Node], _card_context: Dictionary, _previous_result: Variant = null) -> Variant:
	var cards: Array[Card]
	source = source as Player
	match where:
		Where.DRAW_PILE:
			cards = source.get_draw_pile()
		Where.DISCARD_PILE:
			cards = source.get_discard_pile()
		Where.HAND:
			cards = source.get_hand_cards()
		_:
			cards = []
	if animation_name and source is Player:
		source.animate_player(animation_name)
		await source.get_tree().create_timer(animation_delay).timeout
	else:
		await source.get_tree().create_timer(0.1).timeout
	
	var card_count: int = 0
	var hook: Callable = get_callback(source)
	match random_choose_mode:
		RandomChooseMode.NONE:
			if where == Where.HAND:
				card_count = await source.select_hand(ChooseCardContext.new(source, filter_cards(cards), get_hint_text(), min_select, max_select, hook, get_selection_mode()))
			else:
				card_count = await source.select_deck(ChooseCardContext.new(source, filter_cards(cards), get_hint_text(), min_select, max_select, hook, get_selection_mode()))
			return card_count
		RandomChooseMode.ALL:
			for card: Card in cards:
				hook.call(card)
			if where == Where.HAND:
				source.agent.update_hand()
			return len(cards)
		RandomChooseMode.ATTACK:
			cards = cards.filter(func(card: Card): return card.type == Card.Type.ATTACK)
			for card: Card in cards:
				hook.call(card)
			if where == Where.HAND:
				source.agent.update_hand()
			return len(cards)
		RandomChooseMode.NON_ATTACK:
			cards = cards.filter(func(card: Card): return card.type != Card.Type.ATTACK)
			for card: Card in cards:
				hook.call(card)
			if where == Where.HAND:
				source.agent.update_hand()
			return len(cards)
		RandomChooseMode.FIRST:
			if len(cards) > 0:
				var card: Card = cards[0]
				hook.call(card)
				if where == Where.HAND:
					source.agent.update_hand()
	return 0

func filter_cards(cards: Array[Card]) -> Array[Card]:
	match callback:
		Callback.UPGRADE:
			return cards.filter(func(card: Card): return !card.upgraded)
		Callback.APPLY_EXHAUST:
			return cards.filter(func(card: Card): return !card.exhaust)
		Callback.APPLY_ETHEREAL:
			return cards.filter(func(card: Card): return !card.ethereal)
		Callback.APPLY_SLY:
			return cards.filter(func(card: Card): return !card.sly)
	return cards

func get_callback(source: Player) -> Callable:
	match callback:
		Callback.UPGRADE:
			return func(card: Card): card.upgrade()
		Callback.EXHAUST:
			match where:
				Where.HAND:
					return func(card: Card): source.exhaust_hand_card(card)
				Where.DRAW_PILE:
					return func(card: Card): source.exhaust_draw_pile_card(card)
				Where.DISCARD_PILE:
					return func(card: Card): source.exhaust_discard_pile_card(card)
				_:
					return func(_card: Card): return
		Callback.APPLY_EXHAUST:
			return func(card: Card): card.exhaust = true
		Callback.APPLY_ETHEREAL:
			return func(card: Card): card.ethereal = true
		Callback.APPLY_SLY:
			return func(card: Card): card.sly = true
		Callback.PUT_INTO_DRAW_PILE_TOP:
			return func(card: Card):
				if where == Where.DISCARD_PILE:
					source.stats.discard_pile.remove_card(card)
				elif where == Where.HAND:
					source.remove_card_in_hand(card)
				source.stats.draw_pile.add_card_to_top(card)
		Callback.DISCARD:
			return func(card: Card): source.discard_card(card)
		Callback.FREE_FOR_COMBAT:
			# TODO: 应该有一个current_cost属性
			return func(card: Card):
				card.base_cost = 0
				card.upgraded_cost = 0
		Callback.PUT_INTO_HAND:
			return func(card: Card):
				if where == Where.DISCARD_PILE:
					source.stats.discard_pile.remove_card(card)
				elif where == Where.DRAW_PILE:
					source.stats.draw_pile.remove_card(card)
				source.put_card_in_hand(card)
		Callback.PUT_INTO_HAND_AND_FIRST_PLAY_FREE:
			return func(card: Card):
				if where == Where.DISCARD_PILE:
					source.stats.discard_pile.remove_card(card)
				elif where == Where.DRAW_PILE:
					source.stats.draw_pile.remove_card(card)
				card.first_play_free = true
				source.put_card_in_hand(card)
			
	return func(_card: Card): return
	
func get_selection_mode() -> DeckView.SelectionMode:
	match callback:
		Callback.UPGRADE:
			return DeckView.SelectionMode.UPGRADE
		Callback.EXHAUST:
			return DeckView.SelectionMode.SELECT
		Callback.APPLY_EXHAUST:
			return DeckView.SelectionMode.SELECT
		Callback.APPLY_ETHEREAL:
			return DeckView.SelectionMode.SELECT
		Callback.APPLY_SLY:
			return DeckView.SelectionMode.SELECT
		Callback.PUT_INTO_DRAW_PILE_TOP:
			return DeckView.SelectionMode.SELECT
		Callback.DISCARD:
			return DeckView.SelectionMode.SELECT
		Callback.FREE_FOR_COMBAT:
			return DeckView.SelectionMode.SELECT
		Callback.PUT_INTO_HAND:
			return DeckView.SelectionMode.SELECT
		Callback.PUT_INTO_HAND_AND_FIRST_PLAY_FREE:
			return DeckView.SelectionMode.SELECT
	return DeckView.SelectionMode.SELECT

func get_hint_text() -> String:
	var front: String
	var back: String
	if max_select == min_select:
		front = "选择{card}张牌".format({"card": min_select})
	else:
		if min_select == 0:
			front = "选择至多{card}张牌".format({"card": max_select})
		else:
			front = "选择至少{min_select}张牌，至多{max_select}张牌".format({"min_select": min_select, "max_select": max_select})
	match callback:
		Callback.UPGRADE:
			back = "升级"
		Callback.EXHAUST:
			back = "消耗"
		Callback.APPLY_EXHAUST:
			back = "施加消耗"
		Callback.APPLY_ETHEREAL:
			back = "施加虚无"
		Callback.APPLY_SLY:
			back = "施加奇巧"
		Callback.PUT_INTO_DRAW_PILE_TOP:
			back = "加入抽牌堆顶部"
		Callback.DISCARD:
			back = "丢弃"
		Callback.FREE_FOR_COMBAT:
			back = "本场战斗免费"
		Callback.PUT_INTO_HAND:
			back = "加入手牌"
		Callback.PUT_INTO_HAND_AND_FIRST_PLAY_FREE:
			back = "加入手牌"
		_:
			back = ""
	return front + back

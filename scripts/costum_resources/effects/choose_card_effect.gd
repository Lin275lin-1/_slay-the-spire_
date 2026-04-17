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
	DISCARD
}

@export var callback: Callback
@export var where: Where
@export var min_select: int
@export var max_select: int
@export var all: bool

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
	if all:
		for card: Card in cards:
			get_callback(source).call(card)
			source.agent.update_hand()
		return null
	elif where == Where.HAND:
		await source.select_hand(ChooseCardContext.new(source, filter_cards(cards), get_hint_text(), min_select, max_select, get_callback(source), get_selection_mode()))
	else:
		await source.select_deck(ChooseCardContext.new(source, filter_cards(cards), get_hint_text(), min_select, max_select, get_callback(source), get_selection_mode()))
	return null

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
				source.stats.discard_pile.remove_card(card)
				source.stats.draw_pile.add_card_to_top(card)
		Callback.DISCARD:
			return func(card: Card): source.discard_card(card)
			
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
		_:
			back = ""
	return front + back

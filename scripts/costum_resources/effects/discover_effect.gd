class_name DiscoverEffect
extends Effect

@export var card_filter: CardFilter
@export var can_skip: bool = false
@export var upgraded: bool = false
@export var first_play_free: bool = false

func apply(source: Node, _targets: Array[Node], _card_context: Dictionary, _previous_result: Variant = null) -> Variant:
	if source is Player:
		source.discover_card(DiscoverContext.new(card_filter.color, card_filter.type, card_filter.rarity, can_skip, upgraded, first_play_free))
	return null
	

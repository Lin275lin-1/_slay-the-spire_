class_name DiscoverEffect
extends Effect

@export var card_filter: CardFilter
@export var can_skip: bool = false
@export var upgraded: bool = false
@export var first_play_free: bool = false

func apply(source: Node, _targets: Array[Node], _card_context: Dictionary, _previous_result: Variant = null) -> Variant:
	if source is Player:
		if animation_name and source is Player:
			source.animate_player(animation_name)
			await source.get_tree().create_timer(animation_delay).timeout
		else:
			await source.get_tree().create_timer(0.1).timeout
		await source.discover_card(DiscoverContext.new(card_filter.get_color(source), card_filter.type, card_filter.rarity, can_skip, upgraded, first_play_free))
	return null
	

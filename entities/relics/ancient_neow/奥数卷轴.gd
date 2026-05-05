extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, _select_deck_view: DeckView) -> void:
	var candidates := ItemPool.current_card_pool.filter(func(card: Card): return card.rarity == Card.Rarity.RARE)
	char_stats.add_card_to_deck(candidates.pick_random().duplicate())
	

extends Relic

var used := false

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(_context: RewardContext):
			used = false
	)
	Events.card_exhausted.connect(
		func(card: Card):
			if not used and card.type == Card.Type.SKILL:
				var player = owner.get_tree().get_first_node_in_group("ui_player")
				if player:
					(player as Player).put_card_in_hand(card.duplicate())
					used = true
	)

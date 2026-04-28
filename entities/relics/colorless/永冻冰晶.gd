extends Relic

var used := false

func initialize_relic(_owner: RelicUI) -> void:
	Events.card_played.connect(_on_card_played)
	Events.player_turn_ended.connect(func(): used = false)

func _on_card_played(card: Card, card_context: Dictionary) -> void:
	if not used:
		var player = card_context.get("player", null)
		if player and card.type == Card.Type.POWER:
			(player as Player).gain_block(GainBlockContext.new(player, player, 7, [], true))
			used = true

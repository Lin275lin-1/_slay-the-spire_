extends Relic

var available := false

func initialize_relic(owner: RelicUI) -> void:
	Events.card_played.connect(_on_card_played.bind(owner))
	Events.combat_won.connect(
		func(_context: RewardContext):
			count = 0
			owner.update_count()
			available = false	
	)

func activate_relic(owner: RelicUI) -> void:
	if not available:
		available = true
		return
	if count == 0:
		super.activate_relic(owner)
	count = 0
	owner.update_count()
	
func _on_card_played(card: Card, _card_context: Dictionary, owner: RelicUI) -> void:
	if card.type == Card.Type.ATTACK:
		count += 1
		owner.update_count()

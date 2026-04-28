extends Relic

var used = false

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(func(_context: RewardContext): used = false)
	Events.player_hand_drawn.connect(activate_relic.bind(owner))
	
func activate_relic(owner: RelicUI) -> void:
	if used:
		return
	super.activate_relic(owner)
	used = true
	
func deactivate_relic(_owner: RelicUI) -> void:
	pass

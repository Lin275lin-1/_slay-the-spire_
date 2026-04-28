extends Relic

var used = false

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(func(_context: RewardContext): used = false)

func activate_relic(owner: RelicUI) -> void:
	if used:
		return
	super.activate_relic(owner)
	used = true

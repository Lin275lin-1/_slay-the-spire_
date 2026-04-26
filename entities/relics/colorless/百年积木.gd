extends Relic

var used = false

func initialize_relic(owner: RelicUI) -> void:
	Events.player_hit.connect(func(): activate_relic(owner))
	Events.combat_won.connect(func(): used = false)

func activate_relic(owner: RelicUI) -> void:
	if not used:
		super.activate_relic(owner)
		used = true
	

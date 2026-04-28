extends Relic

var used := false

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(_context: RewardContext):
			count = 0
			used = false
			owner.update_count()
	)
	
func activate_relic(owner: RelicUI) -> void:
	if used:
		return
	if count < 7:
		count += 1
	else:
		super.activate_relic(owner)
		used = true
		count = 0
	owner.update_count()
	

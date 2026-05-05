extends Relic

func initialize_relic(owner: RelicUI) -> void:
	count = 3
	owner.update_count()
	
func activate_relic(owner: RelicUI) -> void:
	if count > 0:
		count -= 1
		super.activate_relic(owner)
		owner.update_count()

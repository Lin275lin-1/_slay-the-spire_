extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.after_potion_used.connect(_after_potion_used.bind(owner))

func _after_potion_used(_potion_ui: PotionUI, owner: RelicUI) -> void:
	activate_relic(owner)

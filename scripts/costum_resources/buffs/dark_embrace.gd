class_name DarkEmbraceBuff
extends Buff

func initialize() -> void:
	if agent is Player:
		Events.card_exhausted.connect(_on_card_exhausted)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_card_exhausted(_card: Card) -> void:
	var draw_card_effect := DrawCardEffect.new()
	for i in range(stacks):
		await draw_card_effect.execute(agent, {"player": agent, "target": []}, null)

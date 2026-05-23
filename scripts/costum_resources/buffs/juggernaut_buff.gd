class_name JuggernautBuff
extends Buff

func initialize() -> void:
	if agent is Player:
		agent.before_gain_block.connect(_on_before_gain_block)
	
func get_description() -> String:
	return description.format({"stacks": stacks})
		
func get_modifier() -> Array[Modifier]:
	return []
	
func _on_before_gain_block(_context: Context) -> void:
	var enemies : Array = agent.get_tree().get_nodes_in_group("ui_enemies")
	if len(enemies) == 0:
		return 
	(enemies[randi() % len(enemies)] as Enemy).take_damage_without_signals(stacks)

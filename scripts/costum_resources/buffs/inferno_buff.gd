# 记得改类名
class_name InfernoBuff
extends Buff



	
func initialize() -> void:
	if agent is Player:
		agent.after_turn_started.connect(_on_after_turn_started)
		agent.after_lose_health.connect(_on_after_lose_health)
		
func get_modifier() -> Array[Modifier]:
	return []
	
func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_after_turn_started(_creature: Creature) -> void:
	agent.lose_health(LoseHealthContext.new(agent, agent, 1, [], true))

func _on_after_lose_health(_context: Context) -> void:
	var enemies = agent.get_tree().get_nodes_in_group("ui_enemies")
	# 有点丑陋
	for enemy: Enemy in enemies:
		if enemy:
			enemy.take_damage_without_signals(stacks)

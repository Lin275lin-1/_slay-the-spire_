# 记得改类名
class_name Rupture
extends Buff



	
func initialize() -> void:
	if agent and agent.has_signal("after_lose_health"):
		agent.after_lose_health.connect(_on_after_lose_health)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_after_lose_health(_context: Context) -> void:
	agent.add_buff(ApplyBuffContext.new(agent, agent, stacks, "力量"))

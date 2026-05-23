class_name PoisonDebuff
extends Buff
	
func initialize() -> void:
	if agent and agent.has_signal("before_turn_started"):
		agent.connect("before_turn_started", _on_before_turn_started)
	else:
		printerr("该对象没有turn_started信号")

func _on_before_turn_started(target: Node) -> void:
	target.lose_health(LoseHealthContext.new(self, target, stacks))
	remove_stack(1)

func get_description() -> String:
	return description.format({"stacks": stacks})

# 记得改类名
class_name DemonFormBuff
extends Buff

	
func initialize() -> void:
	if agent and agent.has_signal("before_turn_started"):
		agent.connect("before_turn_started", _on_before_turn_started)

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_before_turn_started(_creature: Node2D) -> void:
	var apply_buff_effect = ApplyBuffEffect.new()
	apply_buff_effect.target_type = Effect.TargetType.SINGLE_ENEMY
	apply_buff_effect.buff_name = "力量"
	apply_buff_effect.buff_stack_provider = NumericProvider.new(stacks)

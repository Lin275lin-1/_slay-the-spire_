# 记得改类名
class_name ThornsBuff
extends Buff

func initialize() -> void:
	if agent and agent.has_signal("after_take_damage"):
		agent.connect("after_take_damage", _on_after_take_damage)
	else:
		printerr("该对象没有after_take_damage信号")
		return

func get_modifier() -> Array[Modifier]:
	return []

func _on_after_take_damage(context: Context) -> void:
	# 不会触发 before_take_damage
	if context.source is Creature:
		context.source.take_damage_without_signals(stacks)

func get_description() -> String:
	return description.format({"stacks": stacks})

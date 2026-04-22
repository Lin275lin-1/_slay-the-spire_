# 记得改类名
class_name ViciousBuff
extends Buff



	
func initialize() -> void:
	if agent is Player:
		agent.after_applied_buff.connect(_on_after_applied_buff)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_after_applied_buff(context: Context) -> void:
	context = (context as ApplyBuffContext)
	if context and context.buff_name == "易伤":
		var draw_card_effect := DrawCardEffect.new()
		draw_card_effect.draw_card_provider = NumericProvider.new(stacks)
		await draw_card_effect.execute(agent, {"player": agent, "targets": []}, null)

# 记得改类名
class_name StampedeBuff
extends Buff



	
func initialize() -> void:
	if agent is Player:
		Events.player_turn_ended.connect(_on_turn_ended)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_turn_ended() -> void:
	var random_play_effect := RandomPlayEffect.new()
	random_play_effect.source = RandomPlayEffect.CardSource.RANDOM_ATTACK
	random_play_effect.where = RandomPlayEffect.Where.HAND
	random_play_effect.random_play_count_provider = NumericProvider.new(stacks)
	random_play_effect.execute(agent, {"player": agent, "targets": agent.get_tree().get_nodes_in_group("ui_enemies")}, null)

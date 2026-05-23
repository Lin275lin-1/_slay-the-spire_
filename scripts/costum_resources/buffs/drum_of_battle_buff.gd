# 记得改类名
class_name DrumOfBattleBuff
extends Buff



	
func initialize() -> void:
	if agent is Player and agent.has_signal("after_turn_started"):
		agent.connect("after_turn_started", _on_after_turn_started)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})
#
#@export var callback: Callback
#@export var where: Where
#@export var min_select: int
#@export var max_select: int
#@export var random_choose_mode: RandomChooseMode
func _on_after_turn_started(player: Creature) -> void:
	player = player as Player
	var choose_card_effect := ChooseCardEffect.new()
	choose_card_effect.callback = ChooseCardEffect.Callback.EXHAUST
	choose_card_effect.where = ChooseCardEffect.Where.DRAW_PILE
	choose_card_effect.random_choose_mode = ChooseCardEffect.RandomChooseMode.FIRST
	for i in range(stacks):
		await choose_card_effect.execute(player, {"player": agent, "targets": []}, null)
		

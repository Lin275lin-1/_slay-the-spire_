class_name ResolutionEntry
extends RefCounted

var source: RefCounted  	# effect列表的拥有者
var effects: Array[Effect] # 需要执行的effect列表
var context: Dictionary # 上下文
var current_index: int = 0 # 接下来要执行的effect的索引
var on_finish: Callable # 执行完成后的回调
var previous_result: Variant = null # 上一个effect的返回值

func _init(source_: RefCounted, effects_: Array[Effect], context_: Dictionary, on_finish_: Callable) -> void:
	source = source_
	effects = effects_
	context = context_
	on_finish = on_finish_

func is_finished() -> bool:
	return current_index >= effects.size()

func get_current_effect() -> Effect:
	return effects[current_index]

func advance() -> void:
	current_index += 1

func is_entry_available() -> bool:
	var targets: Array = context["targets"]
	var player: Node = context["player"]
	if !is_instance_valid(player):
		return false
	if targets.any(func(creature): return !is_instance_valid(creature)):
		return false
	return true

## 要结算的卡牌
#var card: Card : set = _set_card
## 上下文
#var context: Dictionary
#var effects: Array[Effect]
## 当前执行到第n个效果
#var effect_index: int = 0
#
#var previous_result: Variant = null
#
#func _init(card_: Card, context_: Dictionary) -> void:
	#card = card_
	#context = context_
	#effect_index = 0 
#
#func is_finished() -> bool:
	#return effect_index >= card.effects.size()
#
#func get_current_effect() -> Effect:
	#return effects[effect_index]
	#
#func is_entry_available() -> bool:
	#var targets: Array[Node] = context["targets"]
	#if targets.any(func(enemy): return !is_instance_valid(enemy)):
		#return false
	#return true
#
#func _set_card(value: Card) -> void:
	#card = value
	#effects = card.get_effects()

# 记得改类名
class_name SlipperyBuff
extends Buff

func _init() -> void:
	# 一定要在init中设置buff名
	# 在buff进树之前会判断buff_name
	var buff_info: Dictionary = BuffLibrary.buff_data["滑溜"]
	buff_name = buff_info["name"]
	description = buff_info["description"]
	icon = buff_info["icon"]
	
func _ready() -> void:
	type = Type.BUFF
	affect = AFFECT.TARGET
	if agent and agent.has_signal("before_lose_health"):
		agent.connect("before_lose_health", _on_before_take_damage)
	if agent and agent.has_signal("before_take_damage"):
		agent.connect("before_take_damage", _on_before_take_damage)

func get_modifier() -> Array[Modifier]:
	var modifier_1 := Modifier.new(Enums.NumericType.DAMAGE, 0, 1, func(_amount: int): return 1)
	var modifier_2 := Modifier.new(Enums.NumericType.LOSE_HEALTH, 0, 1, func(_amount: int): return 1)
	return [modifier_1, modifier_2]

func _on_before_take_damage(context: Context) -> void:
	context.amount = 1
	remove_stack(1)

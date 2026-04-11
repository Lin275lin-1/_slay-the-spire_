## 记录攻击伤害的来源，目标，伤害量
class_name DamageContext
extends Context

var modifiers: Array[Modifier] = []

func _init(source_: Node, targets_: Array[Node], amount_: int, modifiers_:Array = [], no_modifiers_ :bool = false):
	source = source_
	targets = targets_
	amount = amount_
	no_modifiers = no_modifiers_
	modifiers.append_array(modifiers_)

func get_final_value() -> int:
	if no_modifiers:
		return amount
	return NumericHelper.apply_modifiers(amount, modifiers)

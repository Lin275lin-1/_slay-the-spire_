## 记录攻击伤害的来源，目标，伤害量
class_name GainBlockContext
extends Context

var modifiers: Array[Modifier]

func get_final_value() -> int:
	if no_modifiers:
		return amount
	return NumericHelper.apply_modifiers(amount, modifiers)

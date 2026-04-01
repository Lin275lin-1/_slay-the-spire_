## 记录攻击伤害的来源，目标，伤害量
class_name DamageContext
extends Context

var modifiers: Array[Modifier]

func get_final_value() -> int:
	return NumericHelper.apply_modifiers(amount, modifiers)

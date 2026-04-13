class_name AttackSubIntent
extends SubIntent

@export var damage_provider: NumericProvider
@export var repeat_provider: NumericProvider

func get_text() -> String:
	var repeat = 1
	if repeat_provider:
		repeat = repeat_provider.get_value()
	if repeat > 1:
		return "{damage}x{repeat}".format({"damage": _get_final_value(damage_provider.get_value(null, {})), "repeat": repeat_provider.get_value(null, {})})
	else:
		return "{damage}".format({"damage": _get_final_value(damage_provider.get_value(null, {}))})
		
func get_intent_description() -> String:
	var repeat = 1
	if repeat_provider:
		repeat = repeat_provider.get_value()
	if repeat > 1:
		return "该敌人将要[color=gold]攻击[/color]造成{0}点伤害{1}次".format([damage_provider.get_value(null, {}), repeat])
	return ""

func _get_final_value(base_value: int) -> int:
		var modifiers : Array = []
		if target:
			modifiers = NumericHelper.combine_modifiers(source.get_modifiers_by_type(Enums.NumericType.DAMAGE, Buff.AFFECT.SELF), target.get_modifiers_by_type(Enums.NumericType.DAMAGE, Buff.AFFECT.TARGET))
		else:
			modifiers = source.get_modifiers_by_type(Enums.NumericType.DAMAGE, Buff.AFFECT.SELF)
		return NumericHelper.apply_modifiers(base_value, modifiers)		

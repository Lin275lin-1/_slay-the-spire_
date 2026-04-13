class_name PutCardSubIntent
extends SubIntent

@export var numeric_provider: NumericProvider

func get_text() -> String:
	return ""

func get_intent_description() -> String:
	return "这个敌人将会给你{amount}张[color=gold]状态[/color]牌。".format({"amount": numeric_provider.get_value(null, {})})

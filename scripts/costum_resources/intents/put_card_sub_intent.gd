class_name PutCardSubIntent
extends SubIntent

enum Where{
	DRAW_PILE,
	DISCARD_PILE,
	HAND
}

@export var where: Where
@export var card: Card

func execute(source: Creature, targets: Array[Node]) -> void:
	var put_card_effect = PutCardEffect.new()
	put_card_effect.execute(PutCardContext.new(source, targets, base_value, (where as int), card))
	
func get_text() -> String:
	return ""

func get_intent_name() -> String:
	return "[color=gold]策略[/color]"

func get_intent_description() -> String:
	return "这个敌人将会给你{amount}张[color=gold]状态[/color]牌。".format({"amount": base_value})

class_name PutCardContext
extends Context

var where: int
var card: Card

func _init(source_: Node, target_: Node, amount_: int, where_:int, card_: Card) ->void:
	source = source_
	target = target_
	amount = amount_
	where = where_
	card = card_

class_name ChooseCardContext
extends Context

var max_select: int
var min_select: int
var callback: Callable
var title: String
var cards: Array[Card]

func _init(source_: Node, cards_: Array[Card], title_: String, min_select_: int, max_select_: int, callback_: Callable) -> void:
	source = source_
	cards = cards_
	title = title_
	min_select = min_select_
	max_select = max_select_
	callback = callback_

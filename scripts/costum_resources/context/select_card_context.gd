class_name SelectCardContext
extends Context

var max_select: int
var min_select: int
var title: String
var cards: Array[Card]
var selection_mode: DeckView.SelectionMode

func _init(source_: Node, cards_: Array[Card], title_: String, min_select_: int, max_select_: int, selection_mode_: DeckView.SelectionMode) -> void:
	source = source_
	cards = cards_
	title = title_
	min_select = min_select_
	max_select = max_select_
	selection_mode = selection_mode_

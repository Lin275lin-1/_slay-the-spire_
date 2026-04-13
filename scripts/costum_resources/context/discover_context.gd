class_name DiscoverContext
extends Context

var color: int
var type: int
var rarity: int
var can_skip: bool
var upgraded: bool
var first_play_free: bool

func _init(color_: int, type_: int, rarity_: int, can_skip_: bool, upgraded_: bool, first_play_free_: bool):
	color = color_
	type = type_
	rarity = rarity_
	can_skip = can_skip_
	upgraded = upgraded_
	first_play_free = first_play_free_

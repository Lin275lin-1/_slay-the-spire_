class_name CardFilter
extends Resource

enum COLORTYPE{
	FIEXD,
	CHARACTER,
	EXCEPTIONAL_FOR_CHARACTER
}

@export var color_type: COLORTYPE = COLORTYPE.FIEXD
@export var color: int = 0b0000001
@export var type: int = 0b00001
@export var rarity: int = 0b00001

func get_color(player: Node) -> int:
	if player is Player:
		match color_type:
			COLORTYPE.FIEXD:
				return color
			COLORTYPE.CHARACTER:
				return player.stats.color
			COLORTYPE.EXCEPTIONAL_FOR_CHARACTER:
				return ItemPool.card_type_mask ^ player.stats.color
			_:
				return color
	return color

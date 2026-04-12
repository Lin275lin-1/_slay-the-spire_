extends Node

## 卡牌类型(攻击，技能，能力)
#enum Type {
	#ATTACK = 0b00001, 
	#SKILL = 0b00010, 
	#POWER = 0b00100, 
	#STATUS = 0b01000, 
	#CURSE = 0b10000
	#}
## 卡牌目标类型
#enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}
## 卡牌稀有度
#enum Rarity {
	#COMMON = 0b00001, 
	#UNCOMMON = 0b00010, 
	#RARE = 0b00100, 
	#CURSED = 0b01000, 
	#STATUS = 0b10000
	#}
## 卡牌所属卡牌池
#enum COLOR {
	#RED = 0b0000001,	# 铁甲战士
	#GREEN = 0b0000010,	# 静默猎手
	#ORANGE = 0b0000100, # 储君
	#PINK = 0b0001000,	# 亡灵契约师
	#BLUE = 0b0010000,	# 故障机器人
	#CURSE = 0b0100000,  # 诅咒
	#COLORLESS = 0b1000000, # 无色
#}

var cards_by_color := {
	0b0000001: [],
	0b0000010: [],
	0b0000100: [],
	0b0001000: [],
	0b0010000: [],
	0b0100000: [],
	0b1000000: [],
}
var cards_by_type := {
	0b00001: [],
	0b00010: [],
	0b00100: [],
	0b01000: [],
	0b10000: [],
}
var cards_by_rarity := {
	0b00001: [],
	0b00010: [],
	0b00100: [],
	0b01000: [],
	0b10000: [],
}

var draftable_cards_by_color := {
	0b0000001: [],
	0b0000010: [],
	0b0000100: [],
	0b0001000: [],
	0b0010000: [],
	0b0100000: [],
	0b1000000: [],
}

var discoverable_cards_by_color := {
	0b0000001: [],
	0b0000010: [],
	0b0000100: [],
	0b0001000: [],
	0b0010000: [],
	0b0100000: [],
	0b1000000: [],
}

var color_mask: int = 0b1111111
var type_mask: int = 0b11111
var rarity_mask: int = 0b11111

func _ready():
	load_all_cards("res://entities/cards")
	
func get_cards(color: int, type: int, rarity: int) -> Array[Card]:
	return filter_card_by_rarity(filter_card_by_type(get_cards_by_color(color), type), rarity)

func get_discoverable_cards(color: int, type: int, rarity: int) -> Array[Card]:
	return filter_card_by_rarity(filter_card_by_type(get_discoverable_cards_by_color(color), type), rarity)

#可以被奖励的卡牌
func get_draftable_cards(color: int, type: int, rarity: int) -> Array[Card]:
	return filter_card_by_rarity(filter_card_by_type(get_draftable_cards_by_color(color), type), rarity)

func get_draftable_cards_by_color(mask: int) -> Array[Card]:
	var ret : Array[Card] = []
	for key in draftable_cards_by_color:
		if key & mask != 0:
			ret.append_array(draftable_cards_by_color[key])
	return ret

func get_discoverable_cards_by_color(mask: int) -> Array[Card]:
	var ret : Array[Card] = []
	for key in discoverable_cards_by_color:
		if key & mask != 0:
			ret.append_array(discoverable_cards_by_color[key])
	return ret

func get_cards_by_color(mask: int) -> Array[Card]:
	var ret : Array[Card] = []
	for key in cards_by_color:
		if key & mask != 0:
			ret.append_array(cards_by_color[key])
	return ret

func get_cards_by_type(mask: int) -> Array[Card]:
	var ret : Array[Card] = []
	for key in cards_by_type:
		if key & mask != 0:
			ret.append_array(cards_by_color[key])
	return ret

func get_cards_by_rarity(mask: int) -> Array[Card]:
	var ret : Array[Card] = []
	for key in cards_by_rarity:
		if key & mask != 0:
			ret.append_array(cards_by_color[key])
	return ret

func filter_card_by_color(cards: Array[Card], mask: int) -> Array[Card]:
	return cards.filter(func(card: Card): return card.card_color & mask != 0)

func filter_card_by_type(cards: Array[Card], mask: int) -> Array[Card]:
	return cards.filter(func(card: Card): return card.type & mask != 0)

func filter_card_by_rarity(cards: Array[Card], mask: int) -> Array[Card]:
	return cards.filter(func(card: Card): return card.type & mask != 0)

func load_all_cards(dir_path: String):
	var paths = FileHelper.get_all_resources_in_directory(dir_path)
	for path in paths:
		var resource: Card = ResourceLoader.load(path)
		if resource == null:
			printerr("无法加载{path}")
			continue
		else:
			cards_by_color[resource.card_color & color_mask].append(resource)
			cards_by_rarity[resource.rarity & rarity_mask].append(resource)
			cards_by_type[resource.type & type_mask].append(resource)
			if resource.discoverable:
				discoverable_cards_by_color[resource.card_color & color_mask].append(resource)
			if resource.draftable:
				draftable_cards_by_color[resource.card_color & color_mask].append(resource)
			
			

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
## 药水稀有度
#enum Rarity{
	#COMMON = 0b001,
	#UNCOMMON = 0b010,
	#RARE = 0b100
#}
## 药水所属药水池
#enum COLOR {
	#RED = 0b000001,	# 铁甲战士
	#GREEN = 0b000010,	# 静默猎手
	#ORANGE = 0b000100, # 储君
	#PINK = 0b001000,	# 亡灵契约师
	#BLUE = 0b010000,	# 故障机器人
	#COLORLESS = 0b100000, # 无色
#}
## 遗物类型
#enum COLOR {
	#RED = 0b0000001,	# 铁甲战士
	#GREEN = 0b0000010,	# 静默猎手
	#ORANGE = 0b0000100, # 储君
	#PINK = 0b0001000,	# 亡灵契约师
	#BLUE = 0b0010000,	# 故障机器人
	#COLORLESS = 0b1000000, # 无色
#}
## 遗物稀有度
#enum Rarity{
	#COMMON = 0b000001,
	#UNCOMMON = 0b000010,
	#RARE = 0b000100,
	#STARTER_RELIC = 0b001000,
	#SHOP_RELIC = 0b010000,
	#ANCIENT_RELIC = 0b100000,
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

var potions_by_color := {
	0b000001: [],
	0b000010: [],
	0b000100: [],
	0b001000: [],
	0b010000: [],
	0b100000: [],
}

var potions_by_rarity := {
	0b001: [],
	0b010: [],
	0b100: [],
}

var special_potions: Dictionary = {}

var relics_by_color := {
	0b000001: [],
	0b000010: [],
	0b000100: [],
	0b001000: [],
	0b010000: [],
	0b100000: [],
}

var relics_by_rarity := {
	0b000001: [],
	0b000010: [],
	0b000100: [],
	0b001000: [],
	0b010000: [],
	0b100000: [],
}

var enchantment_dict := {
	
}

var card_color_mask: int = 0b1111111
var card_type_mask: int = 0b11111
var card_rarity_mask: int = 0b11111

var potion_color_mask: int = 0b111111
var potion_rarity_mask: int = 0b111

var relic_color_mask: int = 0b111111
var relic_type_mask: int = 0b1111
var relic_rarity_mask: int = 0b1111

func _ready():
	load_all_cards("res://entities/cards")
	load_all_potions("res://entities/potions")
	load_all_enchantments("res://entities/enchantments")
	
func get_cards(color: int, type: int, rarity: int) -> Array[Card]:
	return filter_card_by_rarity(filter_card_by_type(get_cards_by_color(color), type), rarity)

func get_discoverable_cards(color: int, type: int, rarity: int) -> Array[Card]:
	return filter_card_by_rarity(filter_card_by_type(get_discoverable_cards_by_color(color), type), rarity)

func get_random_discoverable_cards(color: int, type: int, rarity: int, count: int) -> Array[Card]:
	var candidates := get_discoverable_cards(color, type, rarity)
	candidates.shuffle()
	return candidates.slice(0, count)

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
	
func get_potions_by_color(mask: int) -> Array[Potion]:
	var ret : Array[Potion] = []
	for key in potions_by_color:
		if key & mask != 0:
			ret.append_array(potions_by_color[key])
	return ret

func get_potions_by_rarity(mask: int) -> Array[Potion]:
	var ret : Array[Potion] = []
	for key in potions_by_rarity:
		if key & mask != 0:
			ret.append_array(potions_by_rarity[key])
	return ret

func get_special_potion_by_name(potion_name: String) -> Potion:
	return special_potions.get(potion_name, null)

func filter_potion_by_rarity(potions: Array[Potion], mask: int) -> Array[Potion]:
	return potions.filter(func(potion: Potion): return potion.rarity & mask != 0)
	
func filter_potion_by_color(potions: Array[Potion], mask: int) -> Array[Potion]:
	return potions.filter(func(potion: Potion): return potion.potion_color & mask != 0)

func get_potions(color: int, rarity: int) -> Array[Potion]:
	return filter_potion_by_rarity(get_potions_by_color(color), rarity)
	
func get_relics_by_color(mask: int) -> Array[Relic]:
	var ret : Array[Relic] = []
	for key in relics_by_color:
		if key & mask != 0:
			ret.append_array(relics_by_color[key])
	return ret

func get_relics_by_rarity(mask: int) -> Array[Relic]:
	var ret: Array[Relic] = []
	for key in relics_by_rarity:
		if key & mask != 0:
			ret.append_array(relics_by_rarity[key])
	return ret

func filter_relic_by_color(relics: Array[Relic], mask: int) -> Array[Relic]:
	return relics.filter(func(relic: Relic): return relic.relic_color & mask != 0)

func filter_relic_by_rarity(relics: Array[Relic], mask: int) -> Array[Relic]:
	return relics.filter(func(relic: Relic): return relic.rarity & mask != 0)

func get_relics(color: int, rarity: int) -> Array[Relic]:
	return filter_relic_by_rarity(get_relics_by_color(color), rarity)
	
func get_enchantment_by_name(enchantment_name: String) -> Enchantment:
	var enchantment: Enchantment = enchantment_dict.get(enchantment_name, null)
	if enchantment:
		return enchantment.duplicate()
	else:
		return null

func load_all_cards(dir_path: String):
	var paths = FileHelper.get_all_resources_in_directory(dir_path)
	for path in paths:
		var resource: Card = ResourceLoader.load(path)
		if resource == null:
			printerr("无法加载{path}".format(path))
			continue
		else:
			cards_by_color[resource.card_color & card_color_mask].append(resource)
			cards_by_rarity[resource.rarity & card_rarity_mask].append(resource)
			cards_by_type[resource.type & card_type_mask].append(resource)
			if resource.discoverable:
				discoverable_cards_by_color[resource.card_color & card_color_mask].append(resource)
			if resource.draftable:
				draftable_cards_by_color[resource.card_color & card_color_mask].append(resource)

func load_all_potions(dir_path: String):
	var paths = FileHelper.get_all_resources_in_directory(dir_path)
	for path in paths:
		var resource: Potion = ResourceLoader.load(path)
		if resource == null:
			printerr("无法加载{path}".format(path))
			continue
		else:
			if resource.draftable:
				potions_by_color[resource.potion_color & potion_color_mask].append(resource)
				potions_by_rarity[resource.rarity & potion_rarity_mask].append(resource)
			else:
				special_potions[resource.potion_name] = resource

func load_all_relics(dir_path: String):
	var paths = FileHelper.get_all_resources_in_directory(dir_path)
	for path in paths:
		var resource: Relic = ResourceLoader.load(path)
		if resource == null:
			printerr("无法加载{path}".format({"path": path}))
			continue
		else:
			relics_by_color[resource.relic_color & relic_color_mask].append(resource)
			relics_by_rarity[resource.rarity & relic_rarity_mask].append(resource)

func load_all_enchantments(dir_path: String):
	var paths = FileHelper.get_all_resources_in_directory(dir_path)
	for path in paths:
		var resource: Enchantment = ResourceLoader.load(path)
		if resource == null:
			printerr("无法加载{path}".format({"path": path}))
			continue
		else:
			enchantment_dict[resource.enchantment_name] = resource

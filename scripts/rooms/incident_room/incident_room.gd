class_name IncidentRoom
extends Control


#事件信息资源
const SLIPPERY_BRIDGE := preload("res://entities/Incidents/slippery_bridge.tres")
const THIS_OR_THAT:=preload("res://entities/Incidents/this_or_that.tres")
const ROOM_FULL_OF_CHEESE:=preload("res://entities/Incidents/room_full_of_cheese.tres")
const BRAIN_LEECH:=preload("res://entities/Incidents/brain_leech.tres")
const THE_LEGENDS_WERE_TRUE:=preload("res://entities/Incidents/the_legends_were_true.tres")
const JUNGLE_MAZE_ADVENTURE:=preload("res://entities/Incidents/jungle_maze_adventure.tres")
const UNREST_SITE:=preload("res://entities/Incidents/unrest_site.tres")
const LUMINOUS_CHOIR:=preload("res://entities/Incidents/luminous_choir.tres")
const AROMA_OF_CHAOS:=preload("res://entities/Incidents/aroma_of_chaos.tres")


#事件信息数组
var incidentsDataArray: Array = [
	SLIPPERY_BRIDGE,THIS_OR_THAT,
	ROOM_FULL_OF_CHEESE,BRAIN_LEECH,
	THE_LEGENDS_WERE_TRUE,JUNGLE_MAZE_ADVENTURE,
	UNREST_SITE,LUMINOUS_CHOIR,
	AROMA_OF_CHAOS
]



#加载事件信息资源
func loadIncidentData(dir_path: String)->void:
	var paths = FileHelper.get_all_resources_in_directory(dir_path)
	for path in paths:
		var resource: IncidentData = ResourceLoader.load(path)
		if resource == null:
			printerr("无法加载{path}".format(path))
			continue
		else:
			incidentsDataArray.append(resource)


#药水资源
var potion1:Potion=preload("res://entities/potions/格挡药水.tres")
var potion2:Potion=preload("res://entities/potions/火焰药水.tres")
var potion3:Potion=preload("res://entities/potions/爆炸安瓿.tres")
#药水资源数组
var potions:Array[Potion]=[
	potion1,
	potion2,
	potion3,
]

#遗物资源
var relic:Relic=preload("res://entities/relics/colorless/水银沙漏.tres")
var relic1:Relic=preload("res://entities/relics/colorless/灯笼.tres")
var relic2:Relic=preload("res://entities/relics/colorless/锚.tres")
#等待添加新的，天选芝士和藏宝图
var relic3:Relic=preload("res://entities/relics/colorless/锚.tres")
var relic4:Relic=preload("res://entities/relics/colorless/锚.tres")
#遗物资源数组
var relics:Array[Relic]=[
	relic,
	relic1,
	relic2,
	relic3,
	relic4
]

#需要从上层传下来的资源，从run传下来
@export var run_stats:RunStats
@export var char_stats: CharacterStats
@export var deck_view: DeckView

#场景的节点
@onready var background: Sprite2D = $background
@onready var event_title: Label = $eventPanel/eventTitle
@onready var event_description: Label = $eventPanel/eventDescription
@onready var option_1: Button = $eventPanel/optionsContainer/option1
@onready var option_2: Button = $eventPanel/optionsContainer/option2


var incident_data:IncidentData
var random_number
var room_number		#当前房间号
var countop			#当前已经按过几次按钮了
var random_card_number	#随机卡牌

var enchantments:Array

func loadEnchantment(dir_path: String)->void:
	var paths = FileHelper.get_all_resources_in_directory(dir_path)
	for path in paths:
		var resource: Enchantment = ResourceLoader.load(path)
		if resource == null:
			printerr("无法加载{path}".format(path))
			continue
		else:
			enchantments.append(resource)


func init()->void:		
	countop=0
	randomize()  # 初始化随机种子
	random_number = randi_range(0, incidentsDataArray.size()-1)  # 生成0到房间数组大小-1的随机整数
	room_number=random_number
	
	
	set_init_incident_data(incidentsDataArray[room_number])

func set_init_incident_data(data:IncidentData)->void:
	incident_data=data
	background.texture = load(incident_data.backgroundPath)
	event_title.text=incident_data.eventTitile
	event_description.text=incident_data.eventDescription
	option_1.text=incident_data.option1Description
	option_2.text=incident_data.option2Description

	if data.incidentName=="slippery_bridge":
		print("处理滑脚独桥的信息")
		random_card_number = randi_range(0, char_stats.deck.cards.size()-1) 
		var card:Card=char_stats.deck.cards[random_card_number]
		option_1.text="跨越\n\""
		option_1.text+=card.id
		option_1.text+="\""
		option_1.text+=incident_data.option1Description
	#处理冷光合唱团
	if data.incidentName=="luminous_choir":
		if run_stats.gold<100:
			option_1.disabled=true
			option_1.text+="\n锁定：需要至少100金币"
	#处理混沌芳香	
	if data.incidentName=="aroma_of_chaos":
		match char_stats.color:
			0b0000001:
				incident_data.press_op2_description[0]+="\n疼痛算得了什么，我的敌人们必须死。\n"
			0b0000010:
				incident_data.press_op2_description[0]+="\n……狩猎……证明……属于……\n"
			0b0000100:
				incident_data.press_op2_description[0]+="\n我是下一任群星之王……\n"
			0b0001000:
				incident_data.press_op2_description[0]+="\n他们的仇一定要报……我不会动摇……\n"
			0b0010000:
				incident_data.press_op2_description[0]+="\n1100001111000011……\n"
		incident_data.press_op2_description[0]+="香气逐渐消散。"
	

func set_incident_data(data:IncidentData)->void:
	incident_data=data
	background.texture = load(incident_data.backgroundPath)
	event_title.text=incident_data.eventTitile
	event_description.text=incident_data.eventDescription
	option_1.text=incident_data.option1Description
	option_2.text=incident_data.option2Description
	
		

func handle_slippery_bridge_op1()->void:	
	print("原牌组数量")
	print(char_stats.deck.cards.size())
	char_stats.deck.remove_at_i(random_card_number)
	print("卡牌已被移出牌组")
	print("现在牌组数量")
	print(char_stats.deck.cards.size())
	Events.incident_exited.emit()

func handle_this_or_that_op1()->void:
	if countop<incident_data.press_op1_title.size():
		#把“笨拙”加入牌组
		print("原牌组数量")
		print(char_stats.deck.cards.size())
		var card:Card=preload("res://entities/cards/curse_cards/笨拙.tres")
		char_stats.deck.add_card(card)
		print("现在牌组数量")
		print(char_stats.deck.cards.size())
		#把“笨拙”加入牌组
		#添加随机遗物
		print("原来遗物的数量")
		print(run_stats.relics.size())
		random_number = randi_range(0, relics.size()-1)  # 生成0到遗物数组大小-1的随机整数
		run_stats.add_relic(relics[random_number])
		print("现在遗物数量")
		print(run_stats.relics.size())
		#添加随机遗物
		option_2.hide()
	else: 
		Events.incident_exited.emit()
		
func handle_room_full_of_cheese_op1()->void:
	if countop<incident_data.press_op1_title.size():
		print("原牌组卡牌数量")
		print(char_stats.deck.cards.size())
		deck_view.back_button.hide()
		
		var newcards: Array[Card]
		var Randomcards: Array[Card]
		Randomcards=ItemPool.get_draftable_cards(char_stats.color,ItemPool.card_type_mask, Card.Rarity.COMMON)
		Randomcards.shuffle()
		
		var max_cards = 8
		Randomcards = Randomcards.slice(0, min(Randomcards.size(), max_cards))
		
		#从8张牌中选择2张
		newcards = await deck_view.select_card_pile(Randomcards, 2, 2,"选择2张卡牌")
		
		for card in newcards:
			char_stats.deck.add_card(card)
		print("现在牌组卡牌数量")
		print(char_stats.deck.cards.size())
		deck_view.back_button.show()
		option_2.hide()
	else: 
		Events.incident_exited.emit()
	
	
const BATTLE_REWARD_SCENE = preload("res://scenes/rooms/reward/reward_room.tscn")
func _change_view(scene: PackedScene) -> Node:
	if get_child_count() > 0:
		get_child(0).queue_free()
		
	var new_view := scene.instantiate()
	add_child(new_view)
	return new_view
	
func _on_room_exited()->void:
	print("rewarding room exit")
	Events.incident_exited.emit()
	
func handle_brain_leech_op1()->void:
	if countop<incident_data.press_op1_title.size():
		print("原生命值")
		print(char_stats.health)
		#损失5点生命值
		char_stats.take_damage(5)
		print("现在生命值")
		print(char_stats.health)
		
		var reward_scene :=_change_view(BATTLE_REWARD_SCENE) as BattleReward
		
		reward_scene.run_stats = run_stats
		reward_scene.character_stats =char_stats
		reward_scene.add_card_reward(RewardContext.new())
		
		Events.combat_reward_exited.connect(_on_room_exited)
		
		option_2.hide()
	else: 
		Events.incident_exited.emit()


func handle_the_legends_were_true_op1()->void:
	if countop<incident_data.press_op1_title.size():
		print("原来遗物的数量")
		print(run_stats.relics.size())
		run_stats.add_relic(relics[4])
		print("现在遗物数量")
		print(run_stats.relics.size())
		option_2.hide()
	else: 
		Events.incident_exited.emit()
	
func handle_jungle_maze_adventure_op1()->void:
	if countop<incident_data.press_op1_title.size():
		print("原金币值")
		print(run_stats.gold)
		#增加35-65个金币
		random_number=randi_range(0,65-35)
		run_stats.gold=run_stats.gold+35+random_number
		print("现在金币值")
		print(run_stats.gold)
		option_2.hide()
	else: 
		Events.incident_exited.emit()

func handle_unrest_site_op1()->void:
	if countop<incident_data.press_op1_title.size():
		
		print("原生命值")
		print(char_stats.health)
		#损失8点最大生命值
		char_stats._set_max_health(char_stats.max_health-8)
		
		print("现在生命值")
		print(char_stats.health)
		
		#添加随机遗物
		print("原来遗物的数量")
		print(run_stats.relics.size())
		random_number = randi_range(0, relics.size()-1)  # 生成0到遗物数组大小-1的随机整数
		run_stats.add_relic(relics[random_number])
		print("现在遗物数量")
		print(run_stats.relics.size())
		
		option_2.hide()
	else: 
		Events.incident_exited.emit()
	
func handle_luminous_choir_op1()->void:
	if countop<incident_data.press_op1_title.size():
		
		print("原金币值")
		print(run_stats.gold)
		#减少100-149个金币
		random_number=randi_range(100,149)
		run_stats.gold=run_stats.gold-random_number
		if run_stats.gold<0:
			run_stats.gold=0
		print("现在金币值")
		print(run_stats.gold)
		
		print("原来遗物的数量")
		print(run_stats.relics.size())
		random_number=randi_range(0,relics.size()-1)
		run_stats.add_relic(relics[random_number])
		print("现在遗物数量")
		print(run_stats.relics.size())
		option_2.hide()
		
	else: 
		Events.incident_exited.emit()

func handle_aroma_of_chaos_op1()->void:
	if countop<incident_data.press_op1_title.size():

		var newcards: Array[Card]
		newcards = await deck_view.select_card_pile(char_stats.deck.cards, 1, 1,"选择1张卡牌")
		if newcards.size()==0:
			set_incident_data(AROMA_OF_CHAOS)
			countop=countop-1
			print(countop)
			return	
		loadEnchantment("res://entities/enchantments/")
		#var i =char_stats.deck.cards.find(newcards)
		var i =char_stats.deck.cards.find(newcards[0])
		
		char_stats.deck.cards[i].set_echantment(enchantments[0])
		
		option_2.hide()
	else: 
		Events.incident_exited.emit()
	

var op1_handlers: Array[Callable] = [
	handle_slippery_bridge_op1,
	handle_this_or_that_op1,
	handle_room_full_of_cheese_op1,
	handle_brain_leech_op1,
	handle_the_legends_were_true_op1,
	handle_jungle_maze_adventure_op1,
	handle_unrest_site_op1,
	handle_luminous_choir_op1,
	handle_aroma_of_chaos_op1
]

func handleop1()->void:
	op1_handlers[room_number].call()


func _on_option_1_pressed() -> void:
	if countop<incident_data.press_op1_title.size():
		event_title.text=incident_data.press_op1_title[countop]
		event_description.text=incident_data.press_op1_description[countop]
		option_1.text=incident_data.press_op1_op1description[countop]
		option_2.text=incident_data.press_op1_op2description[countop]
		handleop1()
		countop=countop+1
	else:
		handleop1()
		


func handle_slippery_bridge_op2()->void:	
	if countop<incident_data.press_op2_title.size():
		random_card_number = randi_range(0, char_stats.deck.cards.size()-1) 
		var card:Card=char_stats.deck.cards[random_card_number]
		option_1.text="跨越\n\""
		option_1.text+=card.id
		option_1.text+="\""
		option_1.text+=incident_data.option1Description
		print("当前生命值")
		print(char_stats.health)
		print("扣除生命值后当前生命值")
		char_stats.take_damage(countop+3)
		print(char_stats.health)
		
	if countop==incident_data.press_op2_title.size()-1:
		option_1.hide()
	if countop==incident_data.press_op2_title.size():
		Events.incident_exited.emit()	
		


func handle_this_or_that_op2()->void:
	if countop<incident_data.press_op2_title.size():
		print("原生命值")
		print(char_stats.health)
		print("原金币值")
		print(run_stats.gold)
		#损失6点生命值
		char_stats.take_damage(6)
		#增加41-69个金币
		random_number=randi_range(0,69-41)
		run_stats.gold=run_stats.gold+41+random_number
		print("现在生命值")
		print(char_stats.health)
		print("现在金币值")
		print(run_stats.gold)
		option_1.hide()
	else: 
		Events.incident_exited.emit()


func handle_room_full_of_cheese_op2()->void:
	if countop<incident_data.press_op2_title.size():
		print("原生命值")
		print(char_stats.health)
		char_stats.take_damage(14)
		print("现在生命值")
		print(char_stats.health)
		print("原来遗物的数量")
		print(run_stats.relics.size())
		run_stats.add_relic(relics[3])
		print("现在遗物数量")
		print(run_stats.relics.size())
		
		option_1.hide()
	else: 
		Events.incident_exited.emit()

func handle_brain_leech_op2()->void:
	if countop<incident_data.press_op2_title.size():
		print("原牌组卡牌数量")
		print(char_stats.deck.cards.size())
		
		var newcards: Array[Card]
		var Randomcards: Array[Card]
		Randomcards=ItemPool.get_draftable_cards_by_color(char_stats.color)
		Randomcards.shuffle()
		
		var max_cards = 5
		Randomcards = Randomcards.slice(0, min(Randomcards.size(), max_cards))
		
		#从8张牌中选择2张
		newcards = await deck_view.select_card_pile(Randomcards, 1, 1,"选择1张卡牌")
		
		if newcards.size()==0:
			set_incident_data(BRAIN_LEECH)
			countop=countop-1
			print(countop)
			return
		
		for card in newcards:
			char_stats.deck.add_card(card)
		print("现在牌组卡牌数量")
		print(char_stats.deck.cards.size())
		
		
		
		
		option_1.hide()
	else: 
		Events.incident_exited.emit()

func handle_the_legends_were_true_op2()->void:
	if countop<incident_data.press_op2_title.size():
		
		print("原生命值")
		print(char_stats.health)
		char_stats.health=char_stats.health-8
		print("现在生命值")
		print(char_stats.health)
		
		random_number=randi_range(0,potions.size()-1)
		run_stats.add_potion(potions[random_number])
		
		option_1.hide()
	else: 
		Events.incident_exited.emit()


func handle_jungle_maze_adventure_op2()->void:
	if countop<incident_data.press_op2_title.size():
		print("原金币值")
		print(run_stats.gold)
		print("原生命值")
		print(char_stats.health)
		#增加135-165个金币
		random_number=randi_range(0,165-135)
		run_stats.gold=run_stats.gold+135+random_number
		#损失18点生命值
		char_stats.take_damage(18)
		print("现在生命值")
		print(char_stats.health)
		print("现在金币值")
		print(run_stats.gold)
		option_1.hide()
	else: 
		Events.incident_exited.emit()
	
func handle_unrest_site_op2()->void:
	if countop<incident_data.press_op2_title.size():
		
		print("原生命值")
		print(char_stats.health)
		char_stats.heal(ceil(char_stats.max_health-char_stats.health))
		print("现在生命值")
		print(char_stats.health)
		
		#把“睡眠不佳”加入牌组
		print("原牌组数量")
		print(char_stats.deck.cards.size())
		var card:Card=preload("res://entities/cards/curse_cards/睡眠不佳.tres")
		char_stats.deck.add_card(card)
		print("现在牌组数量")
		print(char_stats.deck.cards.size())
		
		option_1.hide()
	else: 
		Events.incident_exited.emit()

func handle_luminous_choir_op2()->void:
	if countop<incident_data.press_op2_title.size():
		
		print("原牌组卡牌数量")
		print(char_stats.deck.cards.size())
		#从当前牌组中选择2张移除
		var newcards: Array[Card]
		newcards = await deck_view.select_card_pile(char_stats.deck.cards, 2, 2,"选择2张卡牌")
		if newcards.size()==0:
			set_incident_data(LUMINOUS_CHOIR)
			countop=countop-1
			print(countop)
			return	
		for card in newcards:
			char_stats.deck.remove_card(card)
		#把“孢子心灵”加入牌组
		var card:Card=preload("res://entities/cards/curse_cards/孢子心灵.tres")
		char_stats.deck.add_card(card)
		print("现在牌组卡牌数量")
		print(char_stats.deck.cards.size())
		option_1.hide()
	else: 
		Events.incident_exited.emit()

func handle_aroma_of_chaos_op2()->void:
	if countop<incident_data.press_op2_title.size():
		
		var upgradableCards: Array[Card]
		
		for card in char_stats.deck.cards:
			if card.upgradable==true:
				upgradableCards.append(card)
		
		
		var newcards: Array[Card]
		newcards = await deck_view.select_card_pile(upgradableCards, 1, 1,"选择1张卡牌")
		if newcards.size()==0:
			set_incident_data(AROMA_OF_CHAOS)
			countop=countop-1
			print(countop)
			return	
		
		newcards[0].upgrade()
		
		
		option_1.hide()
	else: 
		Events.incident_exited.emit()
	

var op2_handlers: Array[Callable] = [
	handle_slippery_bridge_op2,
	handle_this_or_that_op2,
	handle_room_full_of_cheese_op2,
	handle_brain_leech_op2,
	handle_the_legends_were_true_op2,
	handle_jungle_maze_adventure_op2,
	handle_unrest_site_op2,
	handle_luminous_choir_op2,
	handle_aroma_of_chaos_op2
]



func handleop2()->void:
	op2_handlers[room_number].call()

func _on_option_2_pressed() -> void:
	if countop<incident_data.press_op2_title.size():
		event_title.text=incident_data.press_op2_title[countop]
		event_description.text=incident_data.press_op2_description[countop]
		option_1.text=incident_data.press_op2_op1description[countop]
		option_2.text=incident_data.press_op2_op2description[countop]
		handleop2()
		countop=countop+1
	else:
		handleop2()

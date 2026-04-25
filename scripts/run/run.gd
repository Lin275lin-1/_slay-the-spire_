class_name Run
extends Node

#场景资源
const MAIN_MENU_PATH:="res://scenes/main_menu/main_menu.tscn"

const COMBAT_SCENE := preload("res://scenes/rooms/combat_room/combat_room.tscn")
const COMBAT_REWARD_SCENE := preload("res://scenes/rooms/reward/reward_room.tscn")
const CAMPFIRE_SCENE := preload("res://scenes/rooms/campfire_room/campfire_room.tscn")
const MAP_SCENE := preload("res://scenes/map/map.tscn")
const SHOP_SCENE := preload("res://scenes/rooms/shop_room/shop_room.tscn")
const TREASURE_SCENE := preload("res://scenes/rooms/treasure_room/treasure_room.tscn")
const INCIDENT_SCENE := preload("res://scenes/rooms/incident_room/incident_room.tscn")
<<<<<<< HEAD
const ANCIENT_SCENE := preload("res://scenes/rooms/ancient_room/ancient_room.tscn")

=======
>>>>>>> 9a7f11eee5fb6efad8567b78814b06ef8a0a9af3
const BATTLE_REWARD_SCENE = preload("res://scenes/rooms/reward/reward_room.tscn")





@onready var current_room: Node = $CurrentRoom

@onready var combat: Button = %combat
@onready var treasure: Button = %treasure
@onready var shop: Button = %shop
@onready var campfire: Button = %campfire
@onready var rewards: Button = %rewards
@onready var incident: Button = %incident

@onready var map: Button = %map
@onready var map_node: Map = $Map
@onready var top_bar: TopBar = %TopBar
@onready var deck_view: DeckView = %DeckView
@onready var select_deck_view: DeckView = %SelectDeckView
@onready var pause_menu: PauseMenu = $PauseMenu


@export var run_startup: RunStartup

var character: CharacterStats
var stats: RunStats
var save_data:SaveGame

var loading_status: int = 0


func _ready() -> void:
	if not run_startup:
		return
	pause_menu.save_and_quit.connect(
		func():
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
	)
	Events.map_room_selected.connect(_on_map_room_selected)
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUE_RUN:
			_load_run()
			print("加载游戏")


func _on_map_room_selected(room: Room) -> void:
<<<<<<< HEAD
=======
	print("进入房间，保存游戏")
	
	map_node.last_room=room
	
	_save_run(false)
	var scene: PackedScene
>>>>>>> 9a7f11eee5fb6efad8567b78814b06ef8a0a9af3
	match room.type:
		Room.Type.MONSTER, Room.Type.ELITE, Room.Type.BOSS:
			_on_combat_room_entered(room)
			return
		Room.Type.TREASURE:
			_on_treasure_room_entered(room)
			return
		Room.Type.SHOP:
			_on_shop_room_entered(room)
			return
		Room.Type.CAMPFIRE:
			_on_campfire_room_entered(room)
			return
		Room.Type.UNKNOWN:
<<<<<<< HEAD
			_on_incident_room_entered(room)
			return
		Room.Type.ANCIENT:
			_on_ancient_room_entered(room)
			return
		_:
			return

=======
			_handle_unknown_room(scene,room)
			return
		_:
			return

	if room.type == Room.Type.SHOP:
		call_deferred("_change_view_deferred", scene)
	else:
		await _change_view(scene)


################实现问号房逻辑####################
var unknown_room_probs = {
	"combat": 0.10,      # 战斗
	"shop": 0.02,       # 商人
	"treasure": 0.03,   # 宝箱
	"incident": 0.85    # 事件
}

# 保存上一次的房间类型，用于概率补偿
var last_unknown_room_type: String = ""
var compensation_chance: float = 0.0  # 补偿概率

func _handle_unknown_room(scene: PackedScene, room: Room) -> void:
	# 1. 计算当前概率（考虑补偿机制）
	var current_probs = calculate_compensated_probabilities()
	# 2. 根据概率随机选择房间类型
	var room_type = get_random_room_type(current_probs)
	room_type="shop"
	# 3. 根据房间类型设置场景并处理逻辑
	match room_type:
		"combat":
			_on_combat_room_entered(room)
			print("问号房 -> 战斗房间")
			
		"shop":
			scene = SHOP_SCENE
			_change_view(scene)
		"treasure":
			scene = TREASURE_SCENE
			_change_view(scene)
			print("问号房 -> 宝箱房间")
			
		"incident":
			_on_incident_room_entered(room)
			print("问号房 -> 事件房间")
			
		_:
			_on_incident_room_entered(room)
			print("问号房 -> 默认事件房间")
	
	# 4. 更新补偿机制
	update_compensation(room_type)
	
	

func calculate_compensated_probabilities() -> Dictionary:
	var probs = unknown_room_probs.duplicate()  # 复制基础概率
	
	# 如果没有上一次记录，直接返回基础概率
	if last_unknown_room_type == "":
		return probs
	
	# 应用补偿机制
	# 例如：如果上次进了商店，这次商店概率降低，其他类型概率增加
	if compensation_chance > 0:
		# 减少上次出现类型的概率
		probs[last_unknown_room_type] -= compensation_chance
		probs[last_unknown_room_type] = max(probs[last_unknown_room_type], 0.01)  # 保持最小概率
		
		# 将减少的概率平均分配给其他类型
		var other_types = []
		for type in probs.keys():
			if type != last_unknown_room_type:
				other_types.append(type)
		
		var bonus_per_type = compensation_chance / other_types.size()
		for type in other_types:
			probs[type] += bonus_per_type
	
	# 确保概率总和为1
	var total = 0.0
	for prob in probs.values():
		total += prob
	
	if total > 0:
		for type in probs.keys():
			probs[type] /= total
	
	return probs

func get_random_room_type(probabilities: Dictionary) -> String:
	var roll = randf()
	var cumulative = 0.0
	
	for room_type in probabilities.keys():
		cumulative += probabilities[room_type]
		if roll <= cumulative:
			return room_type
	
	# 默认返回事件房间
	return "incident"

func update_compensation(current_room_type: String) -> void:
	# 如果连续出现相同类型，增加补偿概率
	if current_room_type == last_unknown_room_type:
		compensation_chance += 0.05
	else:
		# 重置补偿概率
		compensation_chance = 0.0
	# 记录当前房间类型
	last_unknown_room_type = current_room_type

################实现问号房逻辑####################




>>>>>>> 9a7f11eee5fb6efad8567b78814b06ef8a0a9af3

func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()
	map_node.init(stats)
	save_data=SaveGame.new()
	_show_map()
	

func _save_run(was_on_map:bool)->void:
	save_data.run_stats=stats
	save_data.char_stats=character
	save_data.current_deck=character.deck
	save_data.current_health=character.health
	save_data.last_room=map_node.last_room
	save_data.was_on_map=was_on_map
	
	save_data.potions=stats.potions
	save_data.relics=stats.relics

	save_data.save_data()

<<<<<<< HEAD

=======
func _load_run()->void:
	save_data=SaveGame.load_data()
	assert(save_data,"could not load last save")
	
	character=save_data.char_stats
	stats=save_data.run_stats
	
	character.deck=save_data.current_deck
	character.health=save_data.current_health
	for potion in save_data.potions:
		print("加载药水")
		stats.add_potion(potion)
	for relic in save_data.relics:
		print("加载遗物")	
		stats.add_relic(relic)
	_load_up_top_bar()
	_setup_event_connections()
	
	map_node.load_map(stats,save_data.last_room)
	if save_data.last_room and not save_data.was_on_map:
		print("was on map :false")
		_on_map_room_selected(save_data.last_room)
	else:
		_show_map()
	
func _load_up_top_bar() -> void:
	top_bar.run_stats = stats  
	top_bar.character_stats = character 
	top_bar.initialize(character)
	top_bar.deck_view_requested.connect(deck_view.show_card_pile.bind("你在战斗中将会使用这里的所有卡牌。", false))
	top_bar.relic_handler.add_relic(character.starting_relic)
	top_bar.relic_handler.add_relics(stats.relics)
	top_bar.settings_requested.connect(handleSettingsRequest)
	
>>>>>>> 9a7f11eee5fb6efad8567b78814b06ef8a0a9af3
func _setup_top_bar() -> void:
	top_bar.run_stats = stats  
	top_bar.character_stats = character 
	top_bar.initialize(character)
	top_bar.deck_view_requested.connect(deck_view.show_card_pile.bind("你在战斗中将会使用这里的所有卡牌。", false))
	top_bar.relic_handler.add_relic(character.starting_relic)
	top_bar.settings_requested.connect(handleSettingsRequest)

func handleSettingsRequest()->void:
	pause_menu._pause()
	


func _change_view(scene: PackedScene) -> Node:
	if current_room.get_child_count() > 0:
		current_room.get_child(0).queue_free()
	
	var new_view := scene.instantiate()
	current_room.add_child(new_view)
	return new_view


func _on_combat_won() -> void:
	var reward_scene := await _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	reward_scene.add_gold_reward(map_node.last_room.enemy_encounter.roll_gold_reward())
	reward_scene.add_card_reward()


func _setup_event_connections() -> void:
	Events.combat_won.connect(_on_combat_won)
	Events.combat_reward_exited.connect(_on_room_exited)
	Events.shop_exited.connect(_on_room_exited)
	Events.treasure_room_exited.connect(_on_room_exited)
	Events.incident_exited.connect(_on_room_exited)
	Events.campfire_exited.connect(_on_room_exited)
	Events.ancient_exited.connect(_on_room_exited)
	
	Events.map_exited.connect(_on_map_exited)
	map.pressed.connect(_show_map)
	
	combat.pressed.connect(_on_combat_room_entered.bind(null))
	rewards.pressed.connect(_on_rewards_pressed)
	treasure.pressed.connect(_on_treasure_pressed)
	shop.pressed.connect(_on_shop_pressed)
	campfire.pressed.connect(_on_campfire_pressed)
	incident.pressed.connect(_on_incident_pressed)

	# 先古遗物选择信号（全局连接一次）
	Events.ancient_relic_selected.connect(_on_ancient_relic_selected)


# 测试按钮包装函数
func _on_rewards_pressed():
	await _change_view(COMBAT_REWARD_SCENE)

func _on_treasure_pressed():
	_on_treasure_room_entered(null)

func _on_shop_pressed():
	_on_shop_room_entered(null)

func _on_campfire_pressed():
	_on_campfire_room_entered(null)

func _on_incident_pressed():
	_on_incident_room_entered(null)


func _show_map() -> void:
	if current_room.get_child_count() > 0:
		current_room.get_child(0).hide()
<<<<<<< HEAD
	map_node.show_map()
=======
	map_node.show_map()	
	_save_run(true)

>>>>>>> 9a7f11eee5fb6efad8567b78814b06ef8a0a9af3


func _on_map_exited() -> void:
	map_node.hide()
	if current_room.get_child_count() > 0:
		current_room.get_child(0).show()
	print("map_exited")


func _on_room_exited() -> void:
	map_node.complete_current_room()
	_show_map()


func _on_combat_room_entered(room: Room = null):
	var battle_scene :CombatRoom = await _change_view(COMBAT_SCENE)
	battle_scene.char_stats = character
	if room:
		battle_scene.enemy_encounter = room.enemy_encounter
	battle_scene.relics = top_bar.relic_handler
	battle_scene.start_combat()


func _on_campfire_room_entered(room: Room) -> void:
	var campfire_scene :CampfireRoom = await _change_view(CAMPFIRE_SCENE) as CampfireRoom
	campfire_scene.char_stats = character
	campfire_scene.deck_view = select_deck_view
	campfire_scene.initialize()


<<<<<<< HEAD
func _on_incident_room_entered(room: Room) -> void:
	var incident_scene :IncidentRoom = await _change_view(INCIDENT_SCENE) as IncidentRoom
=======
func _on_campfire_room_entered(room: Room)-> void:
	var capfire_scene :CampfireRoom = _change_view(CAMPFIRE_SCENE) as CampfireRoom
	capfire_scene.char_stats=character
	capfire_scene.deck_view = select_deck_view
	capfire_scene.initialize()

	
func _on_incident_room_entered(room: Room)->void:
	
	var incident_scene :IncidentRoom = _change_view(INCIDENT_SCENE) as IncidentRoom
>>>>>>> 9a7f11eee5fb6efad8567b78814b06ef8a0a9af3
	incident_scene.char_stats = character
	incident_scene.run_stats = stats
	incident_scene.deck_view = select_deck_view
	incident_scene.init()


func _on_shop_room_entered(room: Room) -> void:
	# 商店脚本会自己通过父节点找到 Run 并获取 run_stats / character，无需额外传参
	await _change_view(SHOP_SCENE)


func _on_treasure_room_entered(room: Room) -> void:
	# 宝藏房间同理（假设它内部也有类似的初始化机制）
	await _change_view(TREASURE_SCENE)


func _on_ancient_room_entered(room: Room) -> void:
	# 先古房自己管理遗物逻辑，这部分完全在 ancient_room.gd 内处理
	await _change_view(ANCIENT_SCENE)


func _on_ancient_relic_selected(relic: Relic) -> void:
	# 将选中的先古遗物添加到玩家遗物栏
	top_bar.relic_handler.add_relic(relic)

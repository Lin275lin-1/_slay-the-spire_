class_name Run
extends Node

const COMBAT_SCENE := preload("res://scenes/rooms/combat_room/combat_room.tscn")
const COMBAT_REWARD_SCENE := preload("res://scenes/rooms/reward/reward_room.tscn")
const CAMPFIRE_SCENE := preload("res://scenes/rooms/campfire_room/campfire_room.tscn")
const MAP_SCENE := preload("res://scenes/map/map.tscn")
const SHOP_SCENE := preload("res://scenes/rooms/shop_room/shop_room.tscn")
const TREASURE_SCENE := preload("res://scenes/rooms/treasure_room/treasure_room.tscn")
const INCIDENT_SCENE := preload("res://scenes/rooms/incident_room/incident_room.tscn")
const ANCIENT_SCENE := preload("res://scenes/rooms/ancient_room/ancient_room.tscn")

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

@export var run_startup: RunStartup

var character: CharacterStats
var stats: RunStats

var loading_status: int = 0


func _ready() -> void:
	if not run_startup:
		return
	Events.map_room_selected.connect(_on_map_room_selected)
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUE_RUN:
			map_node.init(stats)
			print("加载游戏")


func _on_map_room_selected(room: Room) -> void:
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
			_on_incident_room_entered(room)
			return
		Room.Type.ANCIENT:
			_on_ancient_room_entered(room)
			return
		_:
			return


func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()
	map_node.init(stats)
	_show_map()


func _setup_top_bar() -> void:
	top_bar.run_stats = stats  
	top_bar.character_stats = character 
	top_bar.initialize(character)
	top_bar.deck_view_requested.connect(deck_view.show_card_pile.bind("你在战斗中将会使用这里的所有卡牌。", false))
	top_bar.relic_handler.add_relic(character.starting_relic)


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
	map_node.show_map()


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


func _on_incident_room_entered(room: Room) -> void:
	var incident_scene :IncidentRoom = await _change_view(INCIDENT_SCENE) as IncidentRoom
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

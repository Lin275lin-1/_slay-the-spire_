class_name Run
extends Node

const COMBAT_SCENE := preload("res://scenes/rooms/combat_room/combat_room.tscn")
const COMBAT_REWARD_SCENE := preload("res://scenes/rooms/reward/reward_room.tscn")
const CAMPFIRE_SCENE := preload("res://scenes/rooms/campfire_room/campfire_room.tscn")
const MAP_SCENE := preload("res://scenes/map/map.tscn")
const SHOP_SCENE := preload("res://scenes/rooms/shop_room/shop_room.tscn")
const TREASURE_SCENE := preload("res://scenes/rooms/treasure_room/treasure_room.tscn")
const INCIDENT_SCENE := preload("res://scenes/rooms/incident_room/incident_room.tscn")

const BATTLE_REWARD_SCENE = preload("res://scenes/rooms/reward/reward_room.tscn")

@onready var current_room: Node = $CurrentRoom

#待删?
@onready var combat: Button = %combat
@onready var treasure: Button = %treasure
@onready var shop: Button = %shop
@onready var campfire: Button = %campfire
@onready var rewards: Button = %rewards
@onready var incident: Button = %incident


@onready var map: Button = %map

#得到map节点
@onready var map_node: Map = $Map
@onready var top_bar: TopBar = %TopBar
#@onready var gold_ui: GoldUI = %TopBar/Left/TopBarGold

@onready var deck_view: DeckView = %DeckView


@export var run_startup: RunStartup

var character: CharacterStats

var stats: RunStats

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
	# 根据房间类型选择对应的场景
	var scene: PackedScene
	match room.type:
		Room.Type.MONSTER:
			_on_combat_room_entered(room)
			return
		Room.Type.ELITE:
			_on_combat_room_entered(room)
			return
		Room.Type.BOSS:
			_on_combat_room_entered(room)
			return
		Room.Type.TREASURE:
			scene = TREASURE_SCENE
		Room.Type.SHOP:
			scene = SHOP_SCENE
		Room.Type.CAMPFIRE:
			_on_campfire_room_entered(room)
			return
		Room.Type.UNKNOWN:
			_on_incident_room_entered(room)
			return
		_:
			return

	# 切换视图
	var new_room_node = _change_view(scene)
		
func _start_run() -> void:
	stats = RunStats.new()
	
	_setup_event_connections()
	_setup_top_bar()
	map_node.init(stats)
	_show_map()
	#debug
	#await get_tree().create_timer(3).timeout
	#stats.gold += 55

func _setup_top_bar() -> void:
	
	#金币状态赋值
	top_bar.run_stats = stats   
	top_bar.initialize(character)
	top_bar.deck_view_requested.connect(deck_view.show_card_pile.bind("你在战斗中将会使用这里的所有卡牌。", false))
	# 遗物
	top_bar.relic_handler.add_relic(character.starting_relic)

func _change_view(scene: PackedScene) -> Node:
	if current_room.get_child_count() > 0:
		current_room.get_child(0).queue_free()
		
	var new_view := scene.instantiate()
	current_room.add_child(new_view)
	
	return new_view
	
func _on_combat_won() -> void:

	var reward_scene :=_change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats =character
	
	#地图
	map_node.complete_current_room()
	#this is temporary code,it will come from real battle encounter data
	# as a dependency
	
	# reward_scene.add_gold_reward(map.last_room.enemy_encounter.roll_gold_reward())
	reward_scene.add_gold_reward(map_node.last_room.enemy_encounter.roll_gold_reward())
	reward_scene.add_card_reward()


	
func _setup_event_connections() -> void:
	Events.combat_won.connect(_on_combat_won)
	
	#这里会造成地图重新初始化,导致legend对应图标无法高亮
	#Events.combat_reward_exited.connect(_change_view.bind(MAP_SCENE))
	#Events.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	#Events.shop_exited.connect(_change_view.bind(MAP_SCENE))
	#Events.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))
	#Events.incident_exited.connect(_change_view.bind(MAP_SCENE))
	
	#房间事件完成后返回到地图并且向前走一步
	Events.combat_reward_exited.connect(_on_room_exited)
	Events.shop_exited.connect(_on_room_exited)
	Events.treasure_room_exited.connect(_on_room_exited)
	Events.incident_exited.connect(_on_room_exited)
	Events.campfire_exited.connect(_on_room_exited)
	
	Events.map_exited.connect(_on_map_exited)
	map.pressed.connect(_show_map)
	#test
	combat.pressed.connect(_on_combat_room_entered)
	rewards.pressed.connect(_change_view.bind(COMBAT_REWARD_SCENE))
	treasure.pressed.connect(_change_view.bind(TREASURE_SCENE))
	shop.pressed.connect(_change_view.bind(SHOP_SCENE))
	campfire.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	incident.pressed.connect(_change_view.bind(INCIDENT_SCENE))

func _show_map() -> void:
	# 隐藏当前房间视图
	if current_room.get_child_count() > 0:
		current_room.get_child(0).hide()
	# 显示地图节点
	map_node.show_map()	
	
	
	
func _on_map_exited() -> void:
	map_node.hide()
	# 重新显示当前房间视图
	if current_room.get_child_count() > 0:
		current_room.get_child(0).show()
		
	print("map_exited")

func _on_room_exited() -> void:
	# 完成当前房间（解锁下一层）
	map_node.complete_current_room()
	# 显示地图
	_show_map()

func _on_combat_room_entered(room: Room):
	var battle_scene :CombatRoom = _change_view(COMBAT_SCENE)
	battle_scene.char_stats = character
	battle_scene.enemy_encounter = room.enemy_encounter
	battle_scene.relics = top_bar.relic_handler
	battle_scene.start_combat()

func _on_campfire_room_entered(room: Room)-> void:
	var capfire_scene :CampfireRoom = _change_view(CAMPFIRE_SCENE) as CampfireRoom
	capfire_scene.char_stats=character
	capfire_scene.deck_view = deck_view

	
func _on_incident_room_entered(room: Room)->void:
	var incident_scene :IncidentRoom = _change_view(INCIDENT_SCENE) as IncidentRoom
	incident_scene.char_stats = character
	incident_scene.run_stats=stats
	incident_scene.deck_view=deck_view
	incident_scene.init()
	

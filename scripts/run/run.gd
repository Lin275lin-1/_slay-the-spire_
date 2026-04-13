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

@export var run_startup: RunStartup

var character: CharacterStats
var stats: RunStats

# 异步加载状态变量
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
	var scene: PackedScene
	match room.type:
		Room.Type.MONSTER, Room.Type.ELITE, Room.Type.BOSS:
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
<<<<<<< HEAD
			scene = INCIDENT_SCENE
=======
			_on_incident_room_entered(room)
			return
>>>>>>> 23c3722bd53555966642911b63e8a6e797942102
		_:
			return

	if room.type == Room.Type.SHOP:
		call_deferred("_change_view_deferred", scene)
	else:
		await _change_view(scene)
		
func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()
	map_node.init(stats)
	_show_map()

func _setup_top_bar() -> void:
	top_bar.run_stats = stats   
	top_bar.initialize(character)
	top_bar.deck_view_requested.connect(deck_view.show_card_pile.bind("你在战斗中将会使用这里的所有卡牌。", false))
	top_bar.relic_handler.add_relic(character.starting_relic)

func _change_view(scene: PackedScene) -> Node:
	if current_room.get_child_count() > 0:
		current_room.get_child(0).queue_free()
	
	# 商店场景特殊处理：使用地图中预加载的资源
	if scene == SHOP_SCENE:
		var loaded_scene = map_node.get_shop_scene()
		if loaded_scene == null:
			# 如果资源还未加载完成，回退同步加载
			loaded_scene = load(scene.resource_path)
		var new_view = loaded_scene.instantiate()
		current_room.add_child.call_deferred(new_view)
		return new_view
	
	# 其他场景正常处理
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
	
	Events.map_exited.connect(_on_map_exited)
	map.pressed.connect(_show_map)
	
	# 测试按钮 - 使用包装函数
	combat.pressed.connect(_on_combat_room_entered.bind(null))
	rewards.pressed.connect(_on_rewards_pressed)
	treasure.pressed.connect(_on_treasure_pressed)
	shop.pressed.connect(_on_shop_pressed)
	campfire.pressed.connect(_on_campfire_pressed)
	incident.pressed.connect(_on_incident_pressed)

# 测试按钮包装函数
func _on_rewards_pressed():
	await _change_view(COMBAT_REWARD_SCENE)

func _on_treasure_pressed():
	await _change_view(TREASURE_SCENE)

func _on_shop_pressed():
	await _change_view(SHOP_SCENE)

func _on_campfire_pressed():
	await _change_view(CAMPFIRE_SCENE)

func _on_incident_pressed():
	await _change_view(INCIDENT_SCENE)

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

<<<<<<< HEAD
func _on_campfire_room_entered(room: Room) -> void:
	var campfire_scene :CampfireRoom = await _change_view(CAMPFIRE_SCENE) as CampfireRoom
	campfire_scene.char_stats = character
	campfire_scene.deck_view = deck_view

func _change_view_deferred(scene: PackedScene) -> void:
	await _change_view(scene)
=======
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
	
>>>>>>> 23c3722bd53555966642911b63e8a6e797942102

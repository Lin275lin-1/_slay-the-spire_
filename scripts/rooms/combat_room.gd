extends Control

@onready var player: Player = $Player
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var combat_ui: BattleUI = $CombatUI
@onready var hand_manager: HandManager = $CombatUI/HandManager
# 子节点的所有char_stats由该节点分发
@export var char_stats: CharacterStats: set = _set_char_stats
const CARD_UI = preload("uid://cunj3kh5og6dc")

func _ready() -> void:
	# 这步应该在开始一局时进行
	var new_stats: CharacterStats = char_stats.create_instance()
	combat_ui.char_stats = new_stats
	hand_manager.char_stats = new_stats
	player.stats = new_stats
	
	Events.turn_ended.connect(player_handler.end_turn)
	# 暂时的
	Events.player_hand_discarded.connect(player_handler.start_turn)
	
	start_combat(new_stats)

func start_combat(char_stats_: CharacterStats) -> void:
	player_handler.start_battle(char_stats_)

func _on_add_card_pressed() -> void:
	player_handler.draw_card()

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value

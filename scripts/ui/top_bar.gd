class_name TopBar
extends Control

signal deck_view_requested(deck: Array[Card])

@onready var card_pile_button: CardPileButton = $Right/Deck/CardPileButton
@onready var avatar: TextureRect = $Left/AvatarContainer/AvatarBg/Avatar

@export var run_stats:RunStats :set = set_run_stats
@onready var gold_label: Label = $Left/TopBarGold/Label
@onready var relic_handler: RelicHandler = $RelicHandler
@onready var top_bar_potion: PotionHandler = $Left/TopBarPotion

func _ready()-> void:
	gold_label.text ="0"
	
	

func initialize(stats: CharacterStats) -> void:
	card_pile_button.card_pile = stats.deck
	avatar.texture = stats.character_icon
	card_pile_button.pressed.connect(deck_view_requested.emit.bind(stats.deck.cards))
	top_bar_potion.initialize(run_stats)
	relic_handler.initialize(run_stats)
	# 测试用
	#var tween = create_tween()
	#tween.tween_callback(func(): run_stats.add_potion(preload("uid://cmilch2jb6xgn")))
	#tween.tween_interval(1.0)
	#tween.tween_callback(func(): run_stats.add_potion(preload("uid://6tqk3prnw8wl")))
	#tween.tween_interval(1.0)
	#tween.tween_callback(func(): run_stats.add_potion(preload("uid://btvj32p8ixefr")))
	#tween.tween_interval(1.0)
	#var tween = create_tween()
	#tween.tween_callback(func(): run_stats.add_relic(preload("uid://d3a7gl0qcwuho")))
	#tween.tween_interval(1.0)
	#tween.tween_callback(func(): run_stats.add_relic(preload("uid://h2lk8mcg6tu5")))
	#tween.tween_interval(1.0)
	#tween.tween_callback(func(): run_stats.add_relic(preload("uid://b5niu17o73g0m")))
	#tween.tween_interval(1.0)
	#tween.tween_callback(func(): run_stats.remove_relic(preload("uid://d3a7gl0qcwuho")))
	#tween.tween_interval(1.0)
	#tween.tween_callback(func(): run_stats.remove_relic(preload("uid://h2lk8mcg6tu5")))
	#tween.tween_interval(1.0)
	#tween.tween_callback(func(): run_stats.remove_relic(preload("uid://b5niu17o73g0m")))
	#tween.tween_interval(1.0)
	#
	
#金币更改
func set_run_stats(new_value:RunStats)->void:
	run_stats =new_value
	if not run_stats.gold_changed.is_connected(_update_gold):
		run_stats.gold_changed.connect(_update_gold)
		_update_gold()
		
func _update_gold()->void:
	gold_label.text=str(run_stats.gold)

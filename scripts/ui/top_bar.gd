class_name TopBar
extends Control

signal deck_view_requested

@onready var card_pile_button: CardPileButton = $Right/Deck/CardPileButton
@onready var avatar: TextureRect = $Left/AvatarContainer/AvatarBg/Avatar

@export var run_stats:RunStats :set = set_run_stats
@onready var gold_label: Label = $Left/TopBarGold/Label


func _ready()-> void:
	gold_label.text ="0"
	

func initialize(stats: CharacterStats) -> void:
	card_pile_button.card_pile = stats.deck
	avatar.texture = stats.character_icon
	card_pile_button.pressed.connect(deck_view_requested.emit)

#金币更改
func set_run_stats(new_value:RunStats)->void:
	run_stats =new_value
	if not run_stats.gold_changed.is_connected(_update_gold):
		run_stats.gold_changed.connect(_update_gold)
		_update_gold()
func _update_gold()->void:
	gold_label.text=str(run_stats.gold)

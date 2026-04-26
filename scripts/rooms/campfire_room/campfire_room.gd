class_name CampfireRoom
extends Control

@export var char_stats:CharacterStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spine_manager: SpineManager = $SpineManager
@onready var forging: Button = $UI/HBoxContainer/forging

var deck_view: DeckView

var forgeable_cards: Array[Card]

func _ready() -> void:
	pass

func initialize() -> void:
	forgeable_cards = char_stats.deck.cards.filter(func(card: Card): return card.can_upgrade())
	if forgeable_cards.is_empty():
		forging.disabled = true

func _on_rest_pressed() -> void:
	char_stats.heal(ceil(char_stats.max_health*0.3))
	animation_player.play("fade_out")
	
func _on_fade_out_finished()->void :
	Events.campfire_exited.emit()
	pass

func _on_forging_pressed() -> void:
	var cards :Array[Card]= await deck_view.select_card_pile(forgeable_cards, 1, 1, "选择一张牌升级", DeckView.SelectionMode.UPGRADE)
	if !cards.is_empty():
		cards[0].upgrade()
		animation_player.play("fade_out")

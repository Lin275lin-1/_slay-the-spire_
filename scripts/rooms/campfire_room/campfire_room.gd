class_name CampfireRoom
extends Control

@export var char_stats:CharacterStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spine_manager: SpineManager = $SpineManager

var deck_view: DeckView

func _ready() -> void:
	pass
	

func _on_rest_pressed() -> void:
	
	char_stats.heal(ceil(char_stats.max_health*0.3))
	animation_player.play("fade_out")
	
func _on_fade_out_finished()->void :
	Events.campfire_exited.emit()
	pass

func _on_forging_pressed() -> void:
	if deck_view:
		var cards = await deck_view.select_card_pile(char_stats.deck.cards.filter(func(card: Card): return !card.upgraded), 1, 1, "选择一张牌升级")
		if !cards.is_empty():
			cards[0].upgrade()
			animation_player.play("fade_out")

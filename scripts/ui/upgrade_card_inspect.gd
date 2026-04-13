class_name UpgradeCardInspect
extends Control

signal confirm(card: Card)
signal cancel()

@onready var color_rect: ColorRect = $ColorRect
@onready var base_card: CardInspectUI = %BaseCard
@onready var upgraded_card: CardInspectUI = %UpgradedCard
@onready var comfirm_button: ComfirmButton = $ComfirmButton
@onready var cancel_button: ComfirmButton = $CancelButton

func _ready() -> void:
	color_rect.gui_input.connect(_on_color_rect_gui_input)
	#show_card(preload("res://entities/characters/ironclad/cards/主宰.tres"))
	comfirm_button.pressed.connect(confirm.emit.bind(base_card.card))
	cancel_button.pressed.connect(cancel.emit)

func show_card(card: Card) -> void:
	base_card.card = card
	var upgraded = card.duplicate()
	upgraded.upgrade()
	upgraded_card.card = upgraded
	show()

func _on_color_rect_gui_input(input: InputEvent) -> void:
	if input.is_action_pressed("left_mouse"):
		hide()

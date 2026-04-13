# merchant_button.gd
extends Control

signal shop_requested()

@onready var highlight_polygon: Line2D = $HighlightPolygon
@onready var reticle: Control = $MerchantSelectionReticle2

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)

func _on_mouse_entered() -> void:
	if highlight_polygon:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(highlight_polygon, "modulate:a", 1.0, 0.15)
	if reticle:
		reticle.visible = true

func _on_mouse_exited() -> void:
	if highlight_polygon:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(highlight_polygon, "modulate:a", 0.0, 0.15)
	if reticle:
		reticle.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shop_requested.emit()

extends Control
@onready var return_button := %Reback

func _on_button_pressed() -> void:
	Events.shop_exited.emit()

func _on_return_button_entered():
	return_button.scale = Vector2(1.1, 1.1)

func _on_return_button_exited():
	return_button.scale = Vector2(1, 1)


func _on_merchant_button_pressed() -> void:
	pass # Replace with function body.

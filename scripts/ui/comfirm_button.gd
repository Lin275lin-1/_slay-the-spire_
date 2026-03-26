class_name ComfirmButton
extends TextureButton

@onready var out_line: TextureRect = $OutLine
@onready var icon: TextureRect = $Icon

@export var out_line_texture: Texture2D
@export var icon_texture: Texture2D

func _ready() -> void:
	out_line.texture = out_line_texture
	icon.texture = icon_texture
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	out_line.show()

func _on_mouse_exited() -> void:
	out_line.hide()

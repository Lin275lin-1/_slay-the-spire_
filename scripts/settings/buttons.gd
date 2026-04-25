extends TextureButton

@onready var label: Label = $Label
@onready var outline: TextureRect = $outline
@onready var pause_button: TextureButton = $"."


# 原始字体大小和颜色，以及文本
@export var original_font_size: int = 40
@export var original_font_color: Color = Color(1,1,1)
@export var text:String

#悬停时的字体大小和颜色
@export var hover_font_size: int = 50
@export var hover_font_color: Color = Color(1.0, 0.9, 0.3)  # 金色

#动画时长
@export var animation_duration: float = 0.2


func _ready() -> void:
	# 将两个信号连接到同一个函数
	pause_button.mouse_entered.connect(_on_button_hover)
	pause_button.mouse_exited.connect(_on_button_hover)
	label.text=text
	_update_label_font_size(original_font_size)
	_update_label_font_color(original_font_color)


func _on_button_hover():
	# 判断当前是进入还是离开
	var mouse_inside = pause_button.is_hovered()
	if mouse_inside:
		outline.show()
		_animate_label(true)	
	else:
		outline.hide()
		_animate_label(false)



func _animate_label(is_hover: bool):
	var tween = create_tween().set_parallel(true)
	
	if is_hover:
		# 悬停时：放大字体 + 变色
		tween.tween_method(_update_label_font_size, original_font_size, hover_font_size, animation_duration)
		tween.tween_property(label, "modulate", hover_font_color, animation_duration)
	else:
		# 离开时：恢复
		tween.tween_method(_update_label_font_size, 
						  hover_font_size, original_font_size, 
						  animation_duration)
		tween.tween_property(label, "modulate", original_font_color, animation_duration)

# 更新字体大小的辅助函数
func _update_label_font_size(size: float):
	label.add_theme_font_size_override("font_size", int(size))
	
# 更新字体颜色的辅助函数
func _update_label_font_color(color: Color):
	label.add_theme_color_override("font_color", color)

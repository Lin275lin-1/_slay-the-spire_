class_name ToolTip
extends Panel

@onready var description: Label = %Description
@onready var margin_container: MarginContainer = $MarginContainer
@onready var vbox_container: VBoxContainer = $MarginContainer/VBoxContainer

func _ready():
	# 设置纹理九宫格（防止边框拉伸）
	var style = get_theme_stylebox("panel")
	if style is StyleBoxTexture:
		print("has_set")
		style.region_rect = Rect2(0, 0, 320, 96)  # 请替换为实际测量值
		# 设置九宫格边距（正值，边框厚度）
		style.expand_margin_left = 8
		style.expand_margin_top = 12
		style.expand_margin_right = 8
		style.expand_margin_bottom = 0
		
func set_text(text: String) -> void:
	description.text = text
	# 等待两帧，确保 Label 完成换行和布局
	await get_tree().process_frame
	await get_tree().process_frame

	# 强制更新内部控件的最小尺寸（可选）
	description.update_minimum_size()
	vbox_container.update_minimum_size()

	# 获取 VBoxContainer 的最小尺寸（包含 Label 及其间距）
	var content_min_size = vbox_container.get_minimum_size()
	# 获取 MarginContainer 的上下边距（场景中 margin_top=12, margin_bottom=12）
	var margin_vertical = margin_container.get_theme_constant("margin_top") + \
						  margin_container.get_theme_constant("margin_bottom")
	# 计算所需高度
	var needed_height = content_min_size.y + margin_vertical
	# 尊重场景中设置的 custom_minimum_size 下限（场景中为 100）
	needed_height = max(needed_height, custom_minimum_size.y)

	# 设置 Panel 尺寸（宽度固定为 200，与场景中 custom_minimum_size.x 一致）
	size = Vector2(280, needed_height+20)

func show_tooltip(text: String, position: Vector2) -> void:
	hide()                     # 先隐藏，避免显示错误的尺寸
	await set_text(text)       # 等待尺寸计算完成
	global_position = position
	#show()

func hide_tooltip() -> void:
	hide()

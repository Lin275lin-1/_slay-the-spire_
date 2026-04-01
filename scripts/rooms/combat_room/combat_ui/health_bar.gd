class_name HealthBar
extends Control

@onready var hp_bar_container: Control = $HPBarContainer
@onready var block_outline: NinePatchRect = %BlockOutline
@onready var mask: NinePatchRect = $HPBarContainer/HPForegroundContainer/Mask
@onready var hp_label: Label = %HpLabel
@onready var block_container: Control = $BlockContainer
@onready var block_label: Label = %BlockLabel
@onready var hp_foreground_container: Control = $HPBarContainer/HPForegroundContainer

@export var mask_length: int

func set_length(length: float) -> void:
	hp_bar_container.size.x = length
	# (235 / 245)是hp_fore_ground_container与hp_bar_container长度比
	hp_foreground_container.size.x = length * (240.0 / 245.0)

func get_length() -> float:
	return hp_bar_container.size.x

func update_stats(stats: Stats) -> void:
	block_outline.visible = stats.block > 0
	block_container.visible = stats.block > 0
	block_label.text = str(stats.block)
	hp_label.text = "%s/%s" % [stats.health, stats.max_health]
	# 根据生命值修改mask长度
	if stats.max_health <= 0:
		return
	mask.size.x = hp_foreground_container.size.x * (float(stats.health) / stats.max_health)

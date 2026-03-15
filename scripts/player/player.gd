class_name Player
extends Node2D

@export var stats: CharacterStats : set = _set_character_stats

@onready var spine_manager: SpineManager = $SpineManager
@onready var health_bar: HealthBar = $HealthBar

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		print("玩家死亡")

func _set_character_stats(value: CharacterStats) -> void:
	stats = value.create_instance()
	# 导入变量的setter会在运行游戏时调用一次
	if not stats.stats_changed.is_connected(_update_stats):
		stats.stats_changed.connect(_update_stats)
	
	_update_player()

func _update_stats() -> void:
	health_bar.update_stats(stats)
	
func _update_player() -> void:
	if stats is not CharacterStats:
		printerr("player出现出错")
		return
	if not is_inside_tree():
		await ready
	
	spine_manager.skeleton_data_res = stats.animation
	_update_stats()

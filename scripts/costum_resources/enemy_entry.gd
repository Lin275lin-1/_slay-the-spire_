class_name EnemyEntry
extends Resource

@export var enemy_stats: EnemyStats
@export var position: Vector2
@export var initial_buff: Dictionary


func get_initial_buffs() -> Dictionary:
	var ret: Dictionary = {}
	for key in initial_buff.keys():
		var buff:Buff = BuffLibrary.buff_scene[key].new()
		ret[buff] = initial_buff[key]
	return ret

class_name Effect
extends RefCounted

enum TargetType{
	NONE, # 无目标
	SELF, # 自己
	SINGLE_ENEMY, #单个敌人
	ALL_ENEMIES, #所有敌人
	RANDOM_ENEMY #随机敌人
}

var target_type: TargetType = TargetType.NONE

var sound : AudioStream

func execute(_context: Context) -> Variant:
	return null

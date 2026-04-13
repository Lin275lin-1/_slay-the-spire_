class_name NumericProvider
extends Resource

enum SourceType{
	FIXED,	# 固定值
	PREVIOUS_RESULT, # 上一个effect的结果
	PREVIOUS_RESULT_MULTIPLY,
	PREVIOUS_RESULT_DIVIDE,
	CUSTOM, # 自定义（应该不需要这么复杂的东西，暂时不实现
	PLAYER_BLOCK, # 根据
	
}

		#NumericEntry.Source.FIXED:
			#return entry.base_value
		#NumericEntry.Source.PLAYER_BLOCK:
			#return player.get_block()
		#NumericEntry.Source.PLAYER_BUFF:
			## 暂时没做
			#return 0
		#NumericEntry.Source.TARGET_BUFF:
			#if not target:
				#return entry.base_value
			#else:
				#var buff = target.get_buff(entry.extra_param["buff_name"])
				#if buff:
					## 有一个我没法复现的bug
					#return entry.base_value + buff.stacks * entry.extra_param["factor"]
				#else:
					#return entry.base_value
		#NumericEntry.Source.ATTACK_PLAYED_THIS_TURN:
			#return player.attack_played_this_turn
		#_:
			#print("未实现")
			#return 0

@export var type: SourceType = SourceType.FIXED
@export var fixed_value: int = 0

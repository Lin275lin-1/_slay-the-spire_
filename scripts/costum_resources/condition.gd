class_name Condition
extends Resource

enum Type{
	ALWAYS, # 总是满足条件
	TARGET_HAS_BUFF, # 目标有buff
	TAEGET_BUFF_MORE_THAN_STACKS, # 目标buff层数多于stacks
	PLAYER_LOSE_HP_THIS_TURN, # 本回合失去过生命
	PLAYER_HAS_BUFF, # 玩家有buff
	PLAYER_BUFF_MORE_THAN_STACKS, # 玩家buff层数多于stacks
	PLAYER_EXHAUSTED_CARD_THIS_TURN, # 玩家本回合消耗过卡牌
	LAST_DRAW_IS_ATTACK, # 上一次抽牌为攻击牌
}

@export var type: Type = Type.ALWAYS

# 多条件，一般不会用到
@export var sub_conditions: Array[Condition] = []
@export var combine_mode: String = "AND"
@export var extra_params: Dictionary

func is_met(_source: Node, target: Node, context: Dictionary, previous_result: Variant = null) -> bool:
	match type:
		Type.ALWAYS:
			return true
		Type.TARGET_HAS_BUFF:
			return (target as Creature).has_buff(extra_params.get("buff_name", ""))
		Type.TAEGET_BUFF_MORE_THAN_STACKS:
			var buff: Buff = (target as Creature).get_buff(extra_params.get("buff_name", ""))
			if buff:
				return buff.stacks > extra_params.get("stacks", 0)
		Type.PLAYER_LOSE_HP_THIS_TURN:
			var player: Player = context.get("player")
			if player:
				return player.health_lost_times_this_turn > 0
		Type.PLAYER_HAS_BUFF:
			var player: Player = context.get("player")
			if player:
				return player.has_buff(extra_params.get("buff_name", ""))
		Type.PLAYER_BUFF_MORE_THAN_STACKS:
			var player: Player = context.get("player")
			if player:
				var buff: Buff = player.get_buff(extra_params.get("buff_name", ""))
				if buff:
					return buff.stacks > extra_params.get("stacks", 0)
		Type.PLAYER_EXHAUSTED_CARD_THIS_TURN:
			var player: Player = context.get("player")
			if player.card_exhausted_this_turn > 0:
				return true
		Type.LAST_DRAW_IS_ATTACK:
			previous_result = (previous_result as Card)
			if previous_result and previous_result.type == Card.Type.ATTACK:
				return true
		_:
			return false
		
	if sub_conditions.size() > 0:
		var results: Array[bool] = sub_conditions.map(func(condiction: Condition): return condiction.is_met(_source, target, context))
		if combine_mode == "AND":
			return results.all(func(flag): return flag)
		else:
			return results.any(func(flag): return flag)
			
	return false

func is_met_without_context(source: Node, target: Node) -> bool:
	match type:
		Type.ALWAYS:
			return true
		Type.TARGET_HAS_BUFF:
			target = (target as Creature)
			if target:
				return target.has_buff(extra_params.get("buff_name", ""))
		Type.TAEGET_BUFF_MORE_THAN_STACKS:
			var buff: Buff = (target as Creature).get_buff(extra_params.get("buff_name", ""))
			if buff:
				return buff.stacks > extra_params.get("stacks", 0)
		Type.PLAYER_LOSE_HP_THIS_TURN:
			var player: Player = source as Player
			if player:
				return player.health_lost_times_this_turn > 0
		Type.PLAYER_HAS_BUFF:
			var player: Player = source as Player
			if player:
				return player.has_buff(extra_params.get("buff_name", ""))
		Type.PLAYER_BUFF_MORE_THAN_STACKS:
			var player: Player = source as Player
			if player:
				var buff: Buff = player.get_buff(extra_params.get("buff_name", ""))
				if buff:
					return buff.stacks > extra_params.get("stacks", 0)
		Type.PLAYER_EXHAUSTED_CARD_THIS_TURN:
			var player: Player = source as Player
			
			if player and player.card_exhausted_this_turn > 0:
				return true
		_:
			return false
		
	if sub_conditions.size() > 0:
		var results: Array[bool] = sub_conditions.map(func(condiction: Condition): return condiction.is_met_without_context(source, target))
		if combine_mode == "AND":
			return results.all(func(flag): return flag)
		else:
			return results.any(func(flag): return flag)
			
	return false

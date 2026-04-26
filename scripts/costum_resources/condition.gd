class_name Condition
extends Resource

enum Type{
	ALWAYS, # 总是满足条件
	TARGET_HAS_BUFF, # 目标有buff
	TARGET_BUFF_MORE_THAN_STACKS, # 目标buff层数多于stacks
	PLAYER_LOSE_HP_THIS_TURN, # 本回合失去过生命
	PLAYER_HAS_BUFF, # 玩家有buff
	PLAYER_BUFF_MORE_THAN_STACKS, # 玩家buff层数多于stacks
	PLAYER_EXHAUSTED_CARD_THIS_TURN, # 玩家本回合消耗过卡牌
	LAST_DRAW_IS_ATTACK, # 上一次抽牌为攻击牌
	EXHAUST_FILE_COUNT_MORE_THAN_COUNT, # 消耗堆数量大于
	PLAYER_HEALTH_EQUAL_OR_LESS_THAN_PERCENT, # 血量低于百分比
	PLAYER_HAS_NO_BLOCK, # 玩家没有格挡
	PLAYER_NOT_PLAYED_ATTACK, # 玩家没有打出过攻击牌
	PLAYER_BLOCK_EQUAL_OR_MORE_THAN_COUNT, # 玩家格挡多余count
	PLAYER_HAS_NO_HAND, # 玩家没有手牌
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
		Type.TARGET_BUFF_MORE_THAN_STACKS:
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
		Type.EXHAUST_FILE_COUNT_MORE_THAN_COUNT:
			var player: Player = context.get("player")
			if player:
				return len(player.get_exhaust_pile()) > extra_params.get("count", 99)
		Type.PLAYER_HEALTH_EQUAL_OR_LESS_THAN_PERCENT:
			var player: Player = context.get("player")
			var percent: int = extra_params.get("percent", 0)
			if player:
				return (float(player.stats.health) / player.stats.max_health) * 100 < percent
		Type.PLAYER_HAS_NO_BLOCK:
			var player: Player = context.get("player")
			if player:
				return player.stats.block == 0
		Type.PLAYER_NOT_PLAYED_ATTACK:
			var player: Player = context.get("player")
			if player:
				return player.attack_played_this_turn == 0
		Type.PLAYER_BLOCK_EQUAL_OR_MORE_THAN_COUNT:
			var player: Player = context.get("player")
			var block_count = extra_params.get("count", 0)
			if player:
				return player.get_block() >= block_count
		Type.PLAYER_HAS_NO_HAND:
			var player: Player = context.get("player")
			if player:
				return len(player.get_hand_cards()) == 0
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
		Type.TARGET_BUFF_MORE_THAN_STACKS:
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
		Type.EXHAUST_FILE_COUNT_MORE_THAN_COUNT:
			var player: Player = source as Player
			if player:
				return len(player.get_exhaust_pile()) > extra_params.get("count", 99)
		Type.PLAYER_HEALTH_EQUAL_OR_LESS_THAN_PERCENT:
			var player: Player = source as Player
			var percent: int = extra_params.get("percent", 0)
			if player:
				return (float(player.stats.health) / player.stats.max_health) * 100 < percent
		Type.PLAYER_HAS_NO_BLOCK:
			var player: Player = source as Player
			if player:
				return player.stats.block == 0
		Type.PLAYER_NOT_PLAYED_ATTACK:
			var player: Player = source as Player
			if player:
				return player.attack_played_this_turn == 0
		Type.PLAYER_BLOCK_EQUAL_OR_MORE_THAN_COUNT:
			var player: Player = source as Player
			var block_count = extra_params.get("count", 0)
			if player:
				return player.get_block() >= block_count
		Type.PLAYER_HAS_NO_HAND:
			var player: Player = source as Player
			if player:
				return len(player.get_hand_cards()) == 0
		_:
			return false
		
	if sub_conditions.size() > 0:
		var results: Array[bool] = sub_conditions.map(func(condiction: Condition): return condiction.is_met_without_context(source, target))
		if combine_mode == "AND":
			return results.all(func(flag): return flag)
		else:
			return results.any(func(flag): return flag)
			
	return false

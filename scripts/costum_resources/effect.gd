class_name Effect
extends Resource

enum TargetType{
	NONE, # 无目标
	SELF, # 自己
	SINGLE_ENEMY, #单个敌人
	ALL_ENEMIES, #所有敌人
	RANDOM_ENEMY #随机敌人
}

@export var target_type: TargetType = TargetType.NONE

func execute(source: Node, card_context: Dictionary = {}, previous_result: Variant = null) -> Variant:
	var targets = get_targets(source, card_context)
	return await apply(source, targets, card_context, previous_result)

func get_targets(source: Node, card_context: Dictionary) -> Array[Node]:
	match target_type:
		TargetType.SELF:
			return [source]
		TargetType.SINGLE_ENEMY:
			var targets :Array[Node] = card_context.get("targets")
			if targets:
				return targets
		TargetType.ALL_ENEMIES:
			return source.get_tree().get_nodes_in_group("ui_enemies")
		TargetType.RANDOM_ENEMY:
			var enemies = source.get_tree().get_nodes_in_group("ui_enemies")
			if enemies.size() > 0:
				return [enemies[randi() % enemies.size()]]
		_:
			return []
	return []			

# 虚函数
func apply(_source: Node, _targets: Array[Node], _card_context: Dictionary, _previous_result: Variant = null) -> Variant:
	return null

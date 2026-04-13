class_name Relic
extends Resource


enum TriggerType {
	START_OF_TURN,
	START_OF_COMBAT,
	END_OF_TURN,
	END_OF_COMBAT,
	EVENT_BASED
}
enum RelicType{
	STARTER_RELIC = 0b0001,
	NORMAL_RELIC = 0b0010,
	ANCIENT_RELIC = 0b0100,
	SHOP_RELIC = 0b1000
}
# 可能需要重构
enum CharacterType{
	COLORLESS,
	IRON_CLAD,
	SILENT,
	REGENT,
	NECROBINDER,
	DEFECT
}
@export var relic_name: String
@export var id: String
@export var icon: Texture
@export_multiline var description: String
@export var trigger_type: TriggerType
@export var character_type: CharacterType
## 使用比特判断类型	 比特从右往左一次为 商店遗物，先古(boss)遗物，普通遗物，初始遗物
## e.g. 输入0b0110: 普通遗物+商店遗物
@export_range(0, 15) var relic_type: int

@export var shop_price: int = 0
@export var on_sale: bool = false
@export var original_price: int = 0

func initialize_relic(_owner: RelicUI) -> void:
	pass

func activate_relic(_owner: RelicUI) -> void:
	pass

# 只有基于事件的遗物需要实现这个方法
# 方法的目的是解除绑定的信号
# 事实上每次新增遗物时会复制一份遗物资源,relicUI被清除时资源也会被清除
# 所有这个函数至少为了保险
func deactivate_relic(_owner: RelicUI) -> void:
	pass

#func can_appear_as_reward(character: CharacterStats, drop_type: Relic.RelicType) -> bool:
	#if (drop_type & relic_type) == 0:
		#return false
	## 有点丑陋
	#match character.character_name:
		#"铁甲战士":
			#return (relic_type == CharacterType.IRON_CLAD) or (relic_type == CharacterType.COLORLESS)
		#"静默猎手":
			#return (relic_type == CharacterType.SILENT) or (relic_type == CharacterType.COLORLESS)
		#_:
			#return false 
	
#debug
func can_appear_as_reward(character: CharacterStats, drop_type: Relic.RelicType) -> bool:
	#print("检查遗物: ", relic_name)
	#print("  relic_type = ", relic_type, " (二进制: ", ("%04b" % relic_type), ")")
	#print("  drop_type  = ", drop_type, " (二进制: ", ("%04b" % drop_type), ")")
	#print("  位与结果   = ", drop_type & relic_type)
	
	if (drop_type & relic_type) == 0:
		#print("  -> 失败：遗物不包含 SHOP_RELIC 标记")
		return false
	
	#print("  character_type = ", character_type)
	#print("  当前角色: ", character.character_name)
	
	match character.character_name:
		"铁甲战士":
			var valid = (character_type == CharacterType.IRON_CLAD) or (character_type == CharacterType.COLORLESS)
			#print("  -> 角色匹配结果: ", valid)
			return valid
		"静默猎手":
			var valid = (character_type == CharacterType.SILENT) or (character_type == CharacterType.COLORLESS)
			#print("  -> 角色匹配结果: ", valid)
			return valid
		_:
			#print("  -> 未知角色，默认返回 false")
			return false

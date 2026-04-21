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
enum COLOR {
	RED = 0b0000001,	# 铁甲战士
	GREEN = 0b0000010,	# 静默猎手
	ORANGE = 0b0000100, # 储君
	PINK = 0b0001000,	# 亡灵契约师
	BLUE = 0b0010000,	# 故障机器人
	COLORLESS = 0b1000000, # 无色
}
enum Rarity{
	COMMON = 0b0001,
	UNCOMMON = 0b0010,
	RARE = 0b0100,
	STARTER_RELIC = 0b1000
}
@export var relic_name: String
@export var id: String
@export var icon: Texture
@export_multiline var description: String
@export var trigger_type: TriggerType
@export var relic_color: COLOR = COLOR.COLORLESS
@export var rarity: Rarity = Rarity.COMMON
## 使用比特判断类型	 比特从右往左一次为 商店遗物，先古(boss)遗物，普通遗物，初始遗物
## e.g. 输入0b1010: 普通遗物+商店遗物
@export_range(0, 15) var relic_type: int
<<<<<<< HEAD


=======
@export var effects: Array[Effect]
>>>>>>> 366aec0e7a48e460ab6d35934a1c3d468b366769

func initialize_relic(_owner: RelicUI) -> void:
	pass

func activate_relic(owner: RelicUI) -> void:
	var player = owner.get_tree().get_first_node_in_group("ui_player")
	# 没有指向性的遗物，所以targets为空
	var relic_context = {"player": player, "targets": []}
	(player as Player).combat_resolver.execute(ResolutionEntry.new(self, effects, relic_context, func(): owner.flash()))
	
# 只有基于事件的遗物需要实现这个方法
# 方法的目的是解除绑定的信号
# 事实上每次新增遗物时会复制一份遗物资源,relicUI被清除时资源也会被清除
# 所以这个函数至少为了保险
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

	match character.color:
		CharacterStats.COLOR.RED:
			var valid = (relic_color == COLOR.RED) or (relic_color == COLOR.COLORLESS)
			#print("  -> 角色匹配结果: ", valid)
			return valid
		CharacterStats.COLOR.GREEN:
			var valid = (relic_color == COLOR.RED) or (relic_color == COLOR.COLORLESS)
			#print("  -> 角色匹配结果: ", valid)
			return valid
		_:
			#print("  -> 未知角色，默认返回 false")
			return false

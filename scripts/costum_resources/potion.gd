class_name Potion
extends Resource

enum TargetType{
	SELF,
	SINGLE_ENEMY,
	ALL_ENEMY
}

enum Rarity{
	COMMON = 0b001,
	UNCOMMON = 0b010,
	RARE = 0b100
}

enum COLOR {
	RED = 0b000001,	# 铁甲战士
	GREEN = 0b000010,	# 静默猎手
	ORANGE = 0b000100, # 储君
	PINK = 0b001000,	# 亡灵契约师
	BLUE = 0b010000,	# 故障机器人
	COLORLESS = 0b100000, # 无色
}

@export var id: String
@export var potion_name: String
@export_multiline var description: String
@export var icon: Texture
@export var outline_icon: Texture
@export var target_type: TargetType
@export var rarity: Rarity = Rarity.COMMON
@export var potion_color: COLOR = COLOR.COLORLESS
@export var effects: Array[Effect]
@export var draftable: bool = true

func play(source: Node, targets: Array[Node], potion_ui: PotionUI) -> void:
	var potion_context = {
		"targets": targets, 
		"player": source
	}
	(source as Player).combat_resolver.execute(ResolutionEntry.new(self, effects, potion_context, func(): Events.after_potion_used.emit(potion_ui)))

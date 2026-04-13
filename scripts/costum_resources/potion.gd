class_name Potion
extends Resource

enum TargetType{
	SELF,
	SINGLE_ENEMY,
	ALL_ENEMY
}

enum Rarity{
	COMMON,
	UNCOMMON,
	RARE
}

@export var id: String
@export var potion_name: String
@export var description: String
@export var icon: Texture
@export var outline_icon: Texture
@export var target_type: TargetType
@export var rarity: Rarity

func play(_source: Node, _targets: Array[Node]) -> void:
	pass

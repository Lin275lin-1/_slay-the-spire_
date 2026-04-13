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

@export var shop_price: int = 0
@export var on_sale: bool = false
@export var original_price: int = 0

func play(_targets: Array[Node]) -> void:
	pass

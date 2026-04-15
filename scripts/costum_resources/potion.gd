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
@export var effects: Array[Effect]

func play(source: Node, targets: Array[Node]) -> void:
	for effect: Effect in effects:
		await effect.execute(source, {"targets": targets}, null)

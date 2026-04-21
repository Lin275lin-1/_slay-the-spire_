class_name NumericEntry
extends Resource

enum AFFECTED_BY {
	SELF,
	TARGET,
	BOTH,
	NONE
}

@export var numeric_type: Enums.NumericType
@export var numeric_provider: NumericProvider
@export var numeric_formula: NumericFormula
@export var placeholder: String
## 受到谁的buff影响(实际上的作用为是否受到buff影响，只使用BOTH或NONE)
@export var affected_by: AFFECTED_BY


func get_base_value(card_context: Dictionary = {}) -> int:
	return numeric_provider.get_value(null, card_context)

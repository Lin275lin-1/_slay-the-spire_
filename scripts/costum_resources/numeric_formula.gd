class_name NumericFormula
extends Resource

enum SourceType{
	FIXED,
	TARGET_BUFF_STACKS
}

@export var source: SourceType = SourceType.FIXED
@export var multiplier: float = 1.0
@export var additive: int = 0
# 只有source = BUFF_STACKS时使用
@export var buff_name: String

func calculate(target: Creature) -> int:
	var base := 0
	match source:
		SourceType.FIXED:
			base = 0
		SourceType.TARGET_BUFF_STACKS:
			var buff := target.get_buff(buff_name)
			base = buff.stacks if buff else 0
	return int(multiplier * (base + additive))

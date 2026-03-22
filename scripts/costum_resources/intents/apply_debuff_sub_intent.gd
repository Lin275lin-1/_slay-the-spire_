class_name ApplyBuffSubIntent
extends SubIntent

@export var buff_id: String

func execute(source: Creature, targets: Array[Node]) -> void:
	targets[0].add_buff(ApplyBuffContext.new(source, targets, base_value, BuffLibrary.buff_scene[buff_id].new()))

func get_text() -> String:
	return ""

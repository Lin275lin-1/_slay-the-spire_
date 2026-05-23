class_name Context
extends RefCounted

var amount: int
var source: Node
var target: Node

var no_modifiers := false


func _init(source_: Node, target_: Node, amount_: int, no_modifiers_ :bool = false):
	source = source_
	target = target_
	amount = amount_
	no_modifiers = no_modifiers_

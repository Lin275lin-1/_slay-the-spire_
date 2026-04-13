class_name Context
extends RefCounted

var amount: int
var source: Node
var targets: Array[Node]

var no_modifiers := false


func _init(source_: Node, targets_: Array[Node], amount_: int, no_modifiers_ :bool = false):
	source = source_
	targets = targets_
	amount = amount_
	no_modifiers = no_modifiers_

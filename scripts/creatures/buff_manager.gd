class_name BuffManager
extends Node

func add_buff(buff_context: ApplyBuffContext) -> Buff:
	var buff_resource: BuffResource = BuffLibrary.get_buff_resource_by_name(buff_context.buff_name)
	var buff_node: Buff = buff_resource.buff_script.new()
	buff_node.buff_resource = buff_resource
	var exist_buff: Buff = null;
	for child: Buff in get_children():
		if child.buff_name == buff_resource.buff_name:
			exist_buff = child
			break
	if exist_buff:
		exist_buff.add_stack(buff_context.amount)
		return exist_buff
	else:
		buff_node.agent = buff_context.target
		add_child(buff_node)
		buff_node.stacks = buff_context.amount	
		return buff_node

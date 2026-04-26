class_name BuffResource
extends Resource

enum BuffType{
	BUFF,
	DEBUFF,
	SPECIAL
}

enum AFFECT{
	SELF, 
	TARGET, 
	ALL
}

@export var buff_id: String
@export var buff_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var buff_type: BuffType
@export var affect: AFFECT
@export var stackable: bool = true
@export var max_stack: int = 999
@export var min_stack: int = 0
# buff逻辑的脚本
@export var buff_script: Script

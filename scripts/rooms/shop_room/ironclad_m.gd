extends Node2D

func _ready():
	var spine = $SpineSprite
	# 延迟一帧确保 Spine 完全初始化
	#await get_tree().process_frame
	spine.get_animation_state().set_animation("relaxed_loop", true, 0)

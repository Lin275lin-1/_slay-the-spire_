@tool
class_name SpineManager
extends SpineSprite

## 由于插件bug，添加anim mix时会闪退，这是在网上复制下来用于在不闪退情况下正常添加的代码
## 使用方法：点击add_anim_mix_entry即可添加一个anim mix

@export var add_anim_mix_entry: bool = false:
	set(value):
		if add_anim_mix_entry == value: return
		add_animation_mix_entry()
	
func add_animation_mix_entry() -> void:
	#This exists as a temporary workaround for the Spine GDExtension glitch that
	#causes Godot to crash when trying to add a new Animation Mix entry in the
	#inspector. Can be removed once Esoteric fixes this glitch.

	if !Engine.is_editor_hint(): return
	var skeleton_file_res: SpineSkeletonFileResource = skeleton_data_res.skeleton_file_res
	skeleton_data_res.skeleton_file_res = null
	skeleton_data_res.animation_mixes.append(SpineAnimationMix.new())
	skeleton_data_res.skeleton_file_res = skeleton_file_res

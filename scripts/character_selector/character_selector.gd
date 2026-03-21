extends Control

#主菜单
#const MAIN_MENU = preload("res://scenes/main_menu/main_menu.tscn")

#背景资源


const CHARACTER_SELECT_SILENT_BG = preload("res://animations/character_select/silent/character_select_silent_bg.png")
const CHARACTER_SELECT_NECROBINDER_BG = preload("res://animations/character_select/necrobinder/character_select_necrobinder_bg.png")

#节点
@onready var background: SpineManager = $background
@onready var backforsomechar: TextureRect = $backforsomechar


#骨骼资源
const CHARACTERSELECT_IRONCLAD_SKEL_DATA = preload("res://animations/character_select/ironclad/characterselect_ironclad_skel_data.tres")
const CHARACTERSELECT_DEFECT_SKEL_DATA = preload("res://animations/character_select/defect/characterselect_defect_skel_data.tres")
const CHARACTERSELECT_NECROBINDER_SKEL_DATA = preload("res://animations/character_select/necrobinder/characterselect_necrobinder_skel_data.tres")
const CHARACTERSELECT_REGENT_SKEL_DATA = preload("res://animations/character_select/regent/characterselect_regent_skel_data.tres")
const CHARACTERSELECT_SILENT_SKEL_DATA = preload("res://animations/character_select/silent/characterselect_silent_skel_data.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.skeleton_data_res=CHARACTERSELECT_IRONCLAD_SKEL_DATA 
	var temp=background.get_animation_state()
	temp.add_animation("animation",true)
	

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/map.tscn")
	


func _on_ironclad_pressed() -> void:
	background.skeleton_data_res=CHARACTERSELECT_IRONCLAD_SKEL_DATA 
	var temp=background.get_animation_state()
	temp.add_animation("animation",true)


func _on_silent_pressed() -> void:
	backforsomechar.texture=CHARACTER_SELECT_SILENT_BG
	background.skeleton_data_res=CHARACTERSELECT_SILENT_SKEL_DATA
	var temp=background.get_animation_state()
	temp.add_animation("animation",true)

func _on_regent_pressed() -> void:
	background.skeleton_data_res=CHARACTERSELECT_REGENT_SKEL_DATA
	var temp=background.get_animation_state()
	temp.add_animation("animation",true)


func _on_necrobinder_pressed() -> void:
	backforsomechar.texture=CHARACTER_SELECT_NECROBINDER_BG
	background.skeleton_data_res=CHARACTERSELECT_NECROBINDER_SKEL_DATA
	var temp=background.get_animation_state()
	temp.add_animation("animation",true)



func _on_defect_pressed() -> void:
	background.skeleton_data_res=CHARACTERSELECT_DEFECT_SKEL_DATA
	var temp=background.get_animation_state()
	temp.add_animation("animation",true)


func _on_button_pressed() -> void:
	var log=get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	print(log)

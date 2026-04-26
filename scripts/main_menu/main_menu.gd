extends Control


#角色选择场景
#const CHARACTER_SELECTOR = preload("res://scenes/character_selector/character_selector.tscn")

const RUN_SCENE=preload("res://scenes/run/run.tscn")

@export var run_startup:RunStartup

#变量名：变量类型
#$...获取子节点
@onready var logo: SpineManager = %logo
@onready var top: SpineManager = $top

#设置界面

@onready var settingscene: Settings = $settingscene

#四个按钮
@onready var continue_button: Button = %Continue
@onready var new_run_button: Button = $"VBoxContainer/New Run"
@onready var settings_button: Button = $VBoxContainer/Settings
@onready var quit_button: Button = $VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp=logo.get_animation_state()
	temp.set_animation('animation',true)
	temp=top.get_animation_state()
	temp.set_animation('animation',true)
	get_tree().paused=false
	continue_button.disabled=SaveGame.load_data()==null
	settingscene.settings_exited.connect(handleSettings)

func handleSettings()->void:
	settingscene.hide()
	get_tree().paused=false

func _on_continue_pressed() -> void:
	run_startup.type=RunStartup.Type.CONTINUE_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)
	print("coutinue button pressed")

func _on_new_run_pressed() -> void:
	print("new run button pressed")
	var log=get_tree().change_scene_to_file("res://scenes/character_selector/character_selector.tscn")
	print(log)
	

func _on_settings_pressed() -> void:
	settingscene.show()
	get_tree().paused=true


func _on_quit_pressed() -> void:
	print("quit button pressed")
	get_tree().quit()


extends Node2D


@onready var bessel_arrow: BesselArrow = $BesselArrow
@onready var area_2d: Area2D = $Area2D


var current_card: CardUI
var current_potion: PotionUI
var current_skill: MainSkillUI
var targeting := false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)
	Events.potion_aim_started.connect(_on_potion_aim_started)
	Events.potion_aim_ended.connect(_on_potion_aim_ended)
	Events.skill_aim_started.connect(_on_skill_aim_started)
	Events.skill_aim_ended.connect(_on_skill_aim_ended)

func _process(_delta: float) -> void:
	if not targeting:
		return 
	if current_card:
		bessel_arrow.reset(current_card.global_position + current_card.size / 2, get_global_mouse_position())
	elif current_potion:
		bessel_arrow.reset(current_potion.global_position + current_potion.size / 2, get_global_mouse_position())
	elif current_skill:
		bessel_arrow.reset(current_skill.global_position + current_skill.size / 4, get_global_mouse_position())
	area_2d.position = get_local_mouse_position()
	
func _on_card_aim_started(card: CardUI) -> void:
	if not card.card.is_single_targeted():
		printerr("bug_at_card_target_selector")
		return
	bessel_arrow.show()
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	current_card = card

func _on_card_aim_ended(_card: CardUI) -> void:
	targeting = false
	area_2d.monitorable = false
	area_2d.monitoring = false
	current_card = null
	bessel_arrow.hide()

func _on_potion_aim_started(potion: PotionUI) -> void:
	if (potion.potion as Potion).target_type != Potion.TargetType.SINGLE_ENEMY:
		printerr("car_target_selector: _on_potion_aim_started")
		return
	bessel_arrow.show()
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	current_potion = potion

func _on_potion_aim_ended(_potion: PotionUI) -> void:
	targeting = false
	area_2d.monitorable = false
	area_2d.monitoring = false
	current_potion = null
	bessel_arrow.hide()

func _on_skill_aim_started(skill_ui: MainSkillUI) -> void:
	if skill_ui.skill.target != Skill.Target.SINGLE_ENEMY:
		printerr("card_target_selector: _on_skill_aim_started")
	bessel_arrow.show()
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	current_skill = skill_ui

func _on_skill_aim_ended(_skill_ui: MainSkillUI) -> void:
	targeting = false
	area_2d.monitorable = false
	area_2d.monitoring = false
	current_skill = null
	bessel_arrow.hide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (not current_card and not current_potion and not current_skill) or not targeting:
		return
	if current_card and not current_card.targets.has(area):
		Events.target_selected.emit(area, current_card.card)
		current_card.targets.append(area)
	elif current_potion and not current_potion.targets.has(area):
		current_potion.targets.append(area)
	elif current_skill and not current_skill.targets.has(area):
		current_skill.targets.append(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if (not current_card and not current_potion and not current_skill) or not targeting:
		return
	if current_card:
		Events.target_unselected.emit(current_card.card)
		current_card.targets.erase(area)
	elif current_potion:
		current_potion.targets.erase(area)
	elif current_skill:
		current_skill.targets.erase(area)

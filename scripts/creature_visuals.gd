class_name CreatureVisuals
extends Node2D

@onready var visuals: SpineManager = $Visuals
@onready var bounds: Control = $Bounds
@onready var center_point: Marker2D = $CenterPoint
@onready var intent_point: Marker2D = $IntentPoint

func get_size() -> Vector2:
	return bounds.size

func get_center_point() -> Vector2:
	return center_point.position
	
func get_intent_size() -> Vector2:
	return intent_point.size

func get_spine_manager() -> SpineManager:
	return visuals

class_name CardTrailVFX
extends Node2D

@export var node_to_follow: Control
var update_sprites := true
var tween: Tween

@onready var sprites: Node2D = $Sprites
@onready var cpu_particles_2d: CPUParticles2D = $Sprites/CPUParticles2D
#public static NCardTrailVfx? Create(Control card, string characterTrailPath)
	#{
		#if (TestMode.IsOn)
		#{
			#return null;
		#}
		#NCardTrailVfx nCardTrailVfx = PreloadManager.Cache.GetScene(characterTrailPath).Instantiate<NCardTrailVfx>(PackedScene.GenEditState.Disabled);
		#nCardTrailVfx._nodeToFollow = card;
		#return nCardTrailVfx;
	#}
	
static func create(card: Control, character_color: CharacterStats.COLOR) -> CardTrailVFX:
	var card_trail_vfx: CardTrailVFX = null
	match character_color:
		CharacterStats.COLOR.RED:
			card_trail_vfx = preload("res://scenes/card_trail/CardTrailIronclad.tscn").instantiate()
	if card_trail_vfx:
		card_trail_vfx.node_to_follow = card
	return card_trail_vfx
	
func _ready() -> void:
	sprites.modulate.a = 0.0;
	tween = create_tween().set_parallel()
	tween.tween_property(sprites, "scale", Vector2.ONE * 0.5, 0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_delay(0.25)
	tween.tween_property(node_to_follow, "modulate:a", 0.75, 0.5)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprites, "modulate:a", 1.0, 1.0)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func _process(_delta: float) -> void:
	if (update_sprites):
		global_position = node_to_follow.global_position
		rotation = node_to_follow.rotation

func fade_out() -> void:
	update_sprites = false;
	if tween:
		tween.kill()
	tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_property(cpu_particles_2d, "amount", 1, 0.5);
	await tween.finished
	queue_free()

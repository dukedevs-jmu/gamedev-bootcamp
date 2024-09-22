extends Node2D
class_name BoulderController

# Gameplay Variables
var boulder_health : int = 3

# Sprites
@export_group("Sprites")
@export var boulder_sprite : Sprite2D
@export var boulder_sprite_pngs : Array[CompressedTexture2D] = [
	preload("res://extras/Boulder Buster/Sprites/Boulder1.png"),
	preload("res://extras/Boulder Buster/Sprites/Boulder2.png"),
	preload("res://extras/Boulder Buster/Sprites/Boulder3.png")
]

# VFX Variables
@export_group("VFX Variables")
@export var damage_vfx : PackedScene = preload("res://extras/Boulder Buster/Scenes/VFX/BoulderDamageVFX.tscn")
@export var destruction_vfx : PackedScene = preload("res://extras/Boulder Buster/Scenes/VFX/BoulderDestructionVFX.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	## Node References
	boulder_sprite = $'Sprite2D'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Damages the boulder by the specified amount
## Returns true if this destroys the boulder. Returns false otherwise
func damage_boulder(damage_amount : int) -> bool:
	# Lower boulder health
	boulder_health -= damage_amount
	
	# If boulder has no HP
	if (boulder_health <= 0):
		# Destroy the boulder
		destroy_boulder()
		return true
	# Boulder has HP
	else:
		# Update sprite
		set_boulder_sprite_by_health()
	
	# Spawn vfx
	spawn_damage_vfx()
	return false

## Sets the boulders sprite to the appropriate sprite based on its health
func set_boulder_sprite_by_health() -> void:
	# Check that boulder HP will match up to a sprite
	if (boulder_health > 0 && boulder_health < 4):
		# Set texture based on boulder HP
		boulder_sprite.texture = boulder_sprite_pngs[3 - boulder_health]

## Spawns the appropriate VFX and deletes this boulder object
func destroy_boulder() -> void:
	spawn_destruction_vfx()
	queue_free()

## Instantiates damage vfx and moves to location
func spawn_damage_vfx() -> void:
	# Create instance of vfx
	var damage_vfx_instance : Node2D = damage_vfx.instantiate()
	
	# Add vfx to scene tree
	get_tree().root.add_child(damage_vfx_instance)
	
	# Set location
	(damage_vfx_instance as Node2D).global_position = global_position

func spawn_destruction_vfx() -> void:
	# Create instance of vfx
	var destruction_vfx_instance : Node2D = destruction_vfx.instantiate()
	
	# Add vfx to scene tree
	get_tree().root.add_child(destruction_vfx_instance)
	
	# Set location
	(destruction_vfx_instance as Node2D).global_position = global_position

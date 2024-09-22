extends Node2D
class_name GameController

@export_group("Prefab References")
## A prefab for spawning boulders
@export var boulder_prefab : PackedScene = preload("res://extras/Boulder Buster/Scenes/Prefabs/Boulder.tscn")
## The prefab for spawning the ball
@export var ball_prefab : PackedScene = preload("res://extras/Boulder Buster/Scenes/Prefabs/Ball.tscn")

# Gameplay Variables
@export_group("Gameplay Variables")
## The players score
@export var score : int = 0
## The players highest score
@export var high_score : int = 0

# Level Customization
@export_group("Level Customization")
## The number of boulder slots
@export var boulder_slots : int = 50
## The list of boulder layouts
@export var boulder_layouts : Array[BoulderLayoutResource] = []
## The current boulder layouts index
var boulder_layout_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("spawn_ball")
	generate_layout(boulder_layouts[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Spawns a ball at 0,0
func spawn_ball() -> void:
	print_debug("True")
	# Create ball instance
	var ball_prefab_instance = ball_prefab.instantiate()
	
	# Add ball to tree
	get_tree().root.add_child(ball_prefab_instance)
	
	(ball_prefab_instance as Node2D).global_position = Vector2(320, 200)

##Todo: Finish
func generate_layout(layout : BoulderLayoutResource) -> void:
	# Iterate through each slot
	for n in range(boulder_slots):
		# If a boulder should be in this slot
		if (layout.boulder_list[n]):
			# Instantiate boulder
			var boulder_instance : Node2D = boulder_prefab.instantiate()
			
			get_tree().root.get_node("Level").get_node("Boulders").add_child(boulder_instance)
			
			(boulder_instance as Node2D).global_position = Vector2(40 + (60 * (n % 10)), 30 + 50 * ((int(n) / int(10))))
			print_debug(str(n), (boulder_instance as Node2D).global_position)

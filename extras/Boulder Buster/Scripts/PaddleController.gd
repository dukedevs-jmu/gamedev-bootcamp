extends Node2D
class_name PaddleController

# Gameplay Variables
@export_group("Gameplay Variables")
## How fast the paddle moves from side to side
@export var move_speed : float = 1.0

# Node Variables
@export_group("Node Variables")
@export var rigid_body : RigidBody2D

## The current movement input (left/right)
var move_input_direction : int = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Node References
	rigid_body = $'RigidBody2D'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input Functions
	move_input()

# Called once per physics update.
func _physics_process(delta):
	# Handler Functions
	move_handling()

## Creates a left-right move axis by combining left and right inputs
## If both keys are pressed, input value cancels to 0
func move_input() -> void:
	move_input_direction = 0
	# Player is using the "left" action
	if (Input.is_action_pressed("left")):
		# Paddle should move left
		move_input_direction -= 1
	if (Input.is_action_pressed("right")):
		# Paddle should move right
		move_input_direction += 1

## Handles applying force based on the move input
func move_handling() -> void:
	# Generate a movement vector along the X axis using move input and move speed
	var move_vector = Vector2(move_input_direction, 0.0) * move_speed * 13500
	
	# Apply force to rigidbody
	rigid_body.apply_central_force(move_vector)

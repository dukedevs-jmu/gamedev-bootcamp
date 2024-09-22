extends Node2D
class_name BallController

# Node Variables
@export_group("Node Variables")
@export var game_controller : GameController
@export var rigid_body : RigidBody2D
@export var bar_collision_sfx : AudioStreamPlayer2D
@export var boulder_collision_sfx : AudioStreamPlayer2D
@export var boulder_destruction_sfx : AudioStreamPlayer2D

# Gameplay Variables
@export_group("Gameplay Variables")
@export var initial_direction : Vector2 = Vector2.DOWN
@export var initial_ball_speed : float = 200.0
@export var ball_max_speed : float = 100.0
@export var ball_acceleration : float = 100.0

# Various
var wall_bounce_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Node References
	rigid_body = $'RigidBody2D'
	bar_collision_sfx = $'BarCollisionSFX'
	boulder_collision_sfx = $'BoulderCollisionSFX'
	boulder_destruction_sfx = $'BoulderDestrutionSFX'
	
	# Initial functions
	apply_initial_ball_force()

# Called once per physics update.
func _physics_process(delta):
	connect_to_game_controller()
	ball_movement_handling()

## Try to get game controller until finds it
func connect_to_game_controller() -> void:
	# Check if already referenced
	if (game_controller == null):
		# Find using gamecontroller group
		if (get_tree().get_first_node_in_group("GameController") != null):
			# Set reference
			game_controller = get_tree().get_first_node_in_group("GameController")

## Sets initial speed of the 
func apply_initial_ball_force() -> void:
	# Normalize initial direction vector
	initial_direction = initial_direction.normalized()
	
	# Apply initial direction vector
	rigid_body.linear_velocity = initial_direction * initial_ball_speed

## Accelerates the ball toward its desired speed
func ball_movement_handling() -> void:
	if (rigid_body.linear_velocity < rigid_body.linear_velocity.normalized() * ball_max_speed):
		rigid_body.apply_central_force(rigid_body.linear_velocity.normalized() * ball_acceleration)
	if (rigid_body.linear_velocity > rigid_body.linear_velocity.normalized() * ball_max_speed):
		rigid_body.linear_velocity =  rigid_body.linear_velocity.normalized() * ball_max_speed

## Receiver function for rb collisions
func _on_rigid_body_2d_body_entered(body):
	# Check if collision was with boulder
	if ((body as Node2D).get_parent() is BoulderController):
		# Damage boulder
		if (((body as Node2D).get_parent() as BoulderController).damage_boulder(1)):
			# Play destruction vfx if destroyed boulder
			boulder_destruction_sfx.play()
		else:
			# Player collision vfx
			boulder_collision_sfx.play()
			
			# Clear wall bounce count
			wall_bounce_count = 0
	# Check if collision was with paddle
	elif ((body as Node2D).get_parent() is PaddleController):
		# Play collision sfx
		bar_collision_sfx.play()
		
		# Clear wall bounce count
		wall_bounce_count = 0
	else:
		wall_bounce_count += 1
		if (wall_bounce_count > 3):
			rigid_body.linear_velocity += Vector2.UP * ball_acceleration

## Spawns a new ball and deletes this instance
func reset_ball() -> void:
	# Make sure gamecontroller exists
	if (game_controller != null):
		# Call game controller to spawn ball
		game_controller.spawn_ball()
		# Delete this instance
		queue_free()

## Receiver function for ball exiting map bounds
func _on_area_2d_body_entered(body):
	# Check if the body is the ball's rigid body
	if (body == rigid_body):
		call_deferred("reset_ball")

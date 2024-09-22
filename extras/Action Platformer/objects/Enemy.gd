extends CharacterBody2D

# Basic funny enemy guy.

const SPEED = 20.0
var gravity = 16

# Movement direction
var direction = -1

# Health variable
var health = 3

# Do this to refer to nodes by a variable name!
@onready var detect_floor = $Sprite2D/DetectFloor

func _physics_process(delta):
	# Apply gravity.
	velocity.y += gravity
	
	# Check if there's a ledge or a wall up ahead using raycasts.
	if not detect_floor.is_colliding() or $Sprite2D/DetectWall.is_colliding():
		# Reverse current direction
		direction *= -1
		$Sprite2D.scale.x = direction
	
	# Handle movement.
	velocity.x = direction * SPEED
	move_and_slide()

# When hit by a bullet, remove 1 health and delete said bullet.
# If no health, delete this enemy.
func _on_hitbox_body_entered(body):
	body.queue_free()
	health -= 1
	if health <= 0:
		queue_free()

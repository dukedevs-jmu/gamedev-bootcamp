extends CharacterBody2D

const SPEED = 200
const GRAVITY = 12
const JUMP_HEIGHT = -320

# Called every physics frame!
# Default physics FPS is 60, and this works
# independent of processor speed.
func _physics_process(delta):
	
	# Apply gravity
	velocity.y += GRAVITY
	
	# Run
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
	else:
		velocity.x = 0
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_HEIGHT
	
	# A built-in function to process this CharacterBody2D's physics.
	# This will be called every frame to allow for smooth movement!
	move_and_slide()

extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 16
const BULLET_SPEED = 300

# Preload the bullet scene at the game's startup
var bullet_scene = preload("res://extras/Action Platformer/objects/bullet/Bullet.tscn")

func _physics_process(delta):
	# You can use functions to keep code organized!
	movement()
	
	# Handle shooting input. Checks to see if a delay timer is
	# finished; if it is, start the timer and shoot!
	#
	# Without the timer, the player could shoot every frame! (60 times a second!)
	#
	if Input.is_action_just_pressed("shoot"):
		# for fun: change to action_pressed for automatic shooting.
		if $ShootDelay.is_stopped():
			$ShootDelay.start()
			shoot()
			$ShootSound.play()

# Handle bullet creation.
func shoot():
	# Create a copy of a bullet scene, then define its position and velocity
	var bullet = bullet_scene.instantiate()
	bullet.position = $Sprite2D/Muzzle.global_position
	bullet.linear_velocity = Vector2(BULLET_SPEED * $Sprite2D.scale.x, 0)
	
	# Get the parent of the player, i.e. the level, and add the new bullet
	get_parent().add_child(bullet)

func movement():
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle walking and animation.
	if Input.is_action_pressed("right"):
		velocity.x = move_toward(velocity.x, SPEED, 16)
		$Sprite2D.scale.x = 1
		$AnimationPlayer.play("run")
	elif Input.is_action_pressed("left"):
		velocity.x = move_toward(velocity.x, -SPEED, 16)
		$Sprite2D.scale.x = -1
		$AnimationPlayer.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, 16)
		$AnimationPlayer.play("idle")
	
	# AnimationPlayer will play the last request.
	# If player is in the air, play the "in_air" animation
	if not is_on_floor():
		$AnimationPlayer.play("in_air")
	
	# Process physics
	move_and_slide()

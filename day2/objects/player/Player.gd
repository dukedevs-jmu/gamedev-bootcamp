extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 20

var gravity = 16

var coins = 0
var seconds = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSound.play()

	# Get the input direction and handle the movement/deceleration.
	# get_axis gets the strength between two inputs, such as buttons, sticks, or triggers.
	var direction = Input.get_axis("left", "right")
	
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
		
		# Handle animation while moving
		if is_on_floor():
			$AnimationPlayer.play("run")
		else:
			$AnimationPlayer.play("in_air")
		
		# Flip sprite to walk direction.
		# scale.x is used instead of flip_h because it
		# also flips the sprite's children.
		if direction > 0:
			$Sprite2D.scale.x = 1
		elif direction < 0:
			$Sprite2D.scale.x = -1
		
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		
		# Handle animation while idle
		if is_on_floor():
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("in_air")
	
	
	# Process physics
	move_and_slide()
	
func add_coin():
	coins += 1
	$CanvasLayer/Label2.text = "Coins: " + str(coins)
	$CoinSound.play()


func _on_timer_timeout():
	seconds += 1
	$CanvasLayer/Label.text = str(seconds)

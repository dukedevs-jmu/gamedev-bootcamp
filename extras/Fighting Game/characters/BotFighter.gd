extends "res://extras/Fighting Game/characters/PlayerFighter.gd"

# Extending scripts allows us to add additional functionality
# without changing existing code

var target = null

func _ready():
	$BotDecisionTimer.start()
	velocity.x = SPEED * -direction

func move_state():
	# Apply gravity
	velocity.y += GRAVITY
	
	if velocity.x != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	
	# Run a timer. When it expires, randomly choose
	# something to do.
	
	if $BotDecisionTimer.is_stopped():
		# Randomize timer wait time and restart it.
		$BotDecisionTimer.wait_time = randf_range(0.05, 0.4)
		$BotDecisionTimer.start()
		# If close, do more attacky stuff. Otherwise, focus on movement.
		if global_position.distance_to(target.global_position) < 200:
			match randi_range(0, 10):
				0, 1, 2:
					$AnimationPlayer.play("attack_light")
					state = ATTACK
				3, 4:
					$AnimationPlayer.play("attack_heavy")
					state = ATTACK
				5, 6:
					state = BLOCK
				7:
					direction *= -1
					velocity.x = SPEED * direction
				8:
					velocity.x = SPEED * direction
				9:
					velocity.x = 0
				10:
					if is_on_floor():
						velocity.y = -JUMP_HEIGHT
		else:
			match randi_range(0, 5):
				0, 1:
					direction *= -1
					velocity.x = SPEED * direction
				2, 3:
					velocity.x = SPEED * direction
				4:
					velocity.x = 0
				5:
					if is_on_floor():
						velocity.y = -JUMP_HEIGHT

func block_state():
	velocity.y += GRAVITY
	if is_on_floor():
		velocity.x = 0
	$AnimationPlayer.play("block")
	# Exit block based on decision timer.
	if $BotDecisionTimer.is_stopped():
		state = MOVE
	

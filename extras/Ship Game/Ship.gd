extends CharacterBody2D

const SPEED = 256

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")

	var direction = Vector2(x_direction, y_direction).normalized()

	# If input, move
	if direction:
		velocity = velocity.move_toward(direction * SPEED, 20)
	else:
		velocity = velocity.move_toward(Vector2(0, 0), 8)
	move_and_slide()
	
	if is_on_wall():
		end_game()
		

func end_game():
	$DeathTimer.start()
	get_parent().can_move = false
	$AnimationPlayer.play("explode")
	$ExplodeSound.play()
	set_physics_process(false)


func _on_death_timer_timeout():
	get_tree().reload_current_scene()

extends CharacterBody2D

const SPEED = 200
const DASH_SPEED = 600
const ACCEL = 16

var dashing = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction:
		velocity = velocity.move_toward(SPEED * (direction.normalized()), ACCEL)
		if Input.is_action_pressed("shoot"):
			if $DashCooldown.is_stopped():
				velocity = DASH_SPEED * (direction.normalized())
				dashing = true
				$DashTimer.start()
				$DashCooldown.start()
				$DashTrail.emitting = true
				$DashSound.play()
	else:
		velocity = velocity.move_toward(Vector2(0, 0), ACCEL)
	
	move_and_slide()
	
	


func _on_hitbox_body_entered(body):
	if dashing:
		body.hurt(1)
	else:
		get_tree().reload_current_scene()


func _on_dash_timer_timeout():
	dashing = false

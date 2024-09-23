extends CharacterBody2D

@export var SPEED = 200
const GRAVITY = 12
const JUMP_HEIGHT = 320

enum {MOVE, ATTACK, BLOCK, PAIN, DIE}
var state = MOVE

var health = 50
var direction = 1

signal health_change
signal die

func _ready():
	$Sprite2D.scale.x = direction

# A basic state machine. Triggers different
# behavior based on the player's state.

func _physics_process(delta):
	move_and_slide()
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		BLOCK:
			block_state()
		PAIN:
			pain_state()
		DIE:
			die_state()
			

func move_state():
	# Apply gravity
	velocity.y += GRAVITY
	
	# Move
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$AnimationPlayer.play("walk")
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$AnimationPlayer.play("walk")
	else:
		velocity.x = 0
		$AnimationPlayer.play("idle")
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# In Godot, Y is negative when moving up.
			velocity.y = -JUMP_HEIGHT
	
	# Attack, either light or heavy
	if Input.is_action_just_pressed("shoot"):
		if Input.is_action_pressed("up"):
			$AnimationPlayer.play("attack_heavy")
		else:
			$AnimationPlayer.play("attack_light")
		state = ATTACK
	
	# Block
	if Input.is_action_just_pressed("down"):
		state = BLOCK

func block_state():
	velocity.y += GRAVITY
	if is_on_floor():
		velocity.x = 0
	$AnimationPlayer.play("block")
	# When down is released, return to moving.
	if Input.is_action_just_released("down"):
		state = MOVE

func attack_state():
	velocity.y += GRAVITY
	if is_on_floor():
		velocity.x = 0

func pain_state():
	$AnimationPlayer.play("pain")
	velocity.y += GRAVITY
	if is_on_floor():
		velocity.x = 0
	

func die_state():
	if is_on_floor():
		velocity.x = 0
	velocity.y += GRAVITY

# When an animation finishes playing (and it doesn't loop),
# return to moving. (unless dead)
func _on_animation_player_animation_finished(anim_name):
	if state != DIE:
		state = MOVE


func _on_hurtbox_area_entered(area):
	# If blocking, take less damage and knockback.
	if state == BLOCK:
		$Block.play()
		health -= max(0, area.damage - 2)
		# Knockback
		velocity += Vector2(area.knockback.x * -$Sprite2D.scale.x, area.knockback.y) * 0.75
	else:
		$Hit.play()
		health -= area.damage
		# Knockback
		velocity += Vector2(area.knockback.x * -$Sprite2D.scale.x, area.knockback.y)
		if health >= 0:
			# Flinch from pain
			state = PAIN
	
	# Notify level to change health bar
	emit_signal("health_change")
	
	# Die...
	if health <= 0:
		state = DIE
		$AnimationPlayer.play("die")
		emit_signal("die")

extends CharacterBody2D

# RPG Demo by Leo Torrijos
# Includes 4 directional movement, a melee attack,
# pots, and interactable objects with text popups.
#
# Controls:
# Arrows - Move
# Z - Melee
# Space - Interact
#
# Many aspects of this character are controlled by
# AnimationPlayer and AnimationTree. They are incredibly
# powerful nodes!
#
# AnimationTree allows fine control of animations and their
# transitions. It must reference an existing AnimationPlayer
# to work.

const SPEED = 64
var state = "MOVE"

var direction = Vector2(0,0)

func _ready():
	# Activate animation tree on startup
	$AnimationTree.active = true

# Finite state machine. Run code based on what the player should
# be able to do in a certain "state"
func _physics_process(delta):
	match state:
		"MOVE":
			move_state()
		"ATTACK":
			attack_state()
		"DIALOGUE":
			dialogue_state()
	
	move_and_slide()

# Control movement.
func move_state():
	# Get input vector
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	
	# normalized() ensures you can't move faster diagonally (two inputs are greater than one!)
	direction = Vector2(x_direction, y_direction).normalized()

	# If input, move
	if direction:
		velocity = direction * SPEED
		# Travel to the "Run" node of the animation tree
		$AnimationTree.get("parameters/playback").travel("Run")
		
		# Change player sprite direction, unless movement is diagonal (causes priority issues)
		if abs(direction.aspect()) != 1:
			$AnimationTree.set("parameters/Run/blend_position", direction)
			$AnimationTree.set("parameters/Idle/blend_position", direction)
			$AnimationTree.set("parameters/Attack/blend_position", direction)
	else:
		velocity = Vector2.ZERO
		$AnimationTree.get("parameters/playback").travel("Idle")
		
	if Input.is_action_just_pressed("shoot"):
		$AnimationTree.get("parameters/playback").travel("Attack")
		$AttackTimer.start()
		state = "ATTACK"
	
	if Input.is_action_just_pressed("jump"):
		if $AttackPivot/Interact.is_colliding():
			$AnimationTree.get("parameters/playback").travel("Idle")
			dialogue($AttackPivot/Interact.get_collider().text)
			$InteractSound.play()
			state = "DIALOGUE"

func attack_state():
	velocity = Vector2.ZERO

func dialogue_state():
	velocity = Vector2.ZERO
	if Input.is_action_just_pressed("jump"):
		state = "MOVE"
		$DialogueBox.hide()

func dialogue(text):
	$DialogueBox/Label.text = text
	$DialogueBox.show()

func _on_attack_timer_timeout():
	state = "MOVE"

extends CharacterBody2D

# @export allows us to edit a variable in
# the Inspector (on right). This is useful for
# changing values between individual instances.
# See BasicEnemy.tscn, BigEnemy.tscn

@export var health = 1
@export var speed = 64
@export var chase_range  =100

var player = null
var direction = Vector2(1, 0)

func _ready():
	var rand_float = randf_range(0, 1)
	direction = Vector2(rand_float, 1 - rand_float)

func _physics_process(delta):
	
	var player_pos = player.global_position
	
	if global_position.distance_to(player_pos) <= chase_range:
		direction = global_position.direction_to(player_pos)
	else:
		if is_on_wall() and $BounceDelay.is_stopped():
			direction = direction.bounce(get_wall_normal())
			$BounceDelay.start()
	
	velocity = direction.normalized() * speed
	move_and_slide()

func hurt(damage):
	health -= damage
	$BasicAnimations.play("pain")
	if health <= 0:
		queue_free()
	

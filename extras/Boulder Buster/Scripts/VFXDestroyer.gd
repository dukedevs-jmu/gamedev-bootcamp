extends Node2D

@export_group("Customization")
@export var seconds_til_destruction : float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set all particle children to emit
	for child in get_children():
		if child is GPUParticles2D:
			child.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	destruction_countdown(delta)

## Destroys this object after seconds_til_destruction seconds
func destruction_countdown(delta) -> void:
	# Timer still going
	if (seconds_til_destruction > 0):
		# Increment timer
		seconds_til_destruction -= delta
	# Timer finished
	else:
		# Destroy object
		queue_free()

# Grid movement example provided by Diego Navia
#
# This code provides basic movement for a game where player moves between tiles
# or in a grid (just like chess).

extends CharacterBody2D

# Reference to the RayCast2D node
@onready var ray_cast_2d: RayCast2D = $RayCast2D # Note that we use $ sign to refer child Nodes

# This is a dictionary! Maps our custom input map movements to a vector value
const inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"down": Vector2.DOWN,
	"up": Vector2.UP
}

# Stores the grid size, in this case, we use 16x16 per tile
# In case you would have different tilesets with higher resolution (ex. 32x32) 
# the grid_size variable should be assigned to that new size
var grid_size = 16

# Player moves with the appropriate direction from an input key if any input map action is triggered
# If you want to learn more about _unhandled_input just hover your cursor over the function by holding
# the ctrl or command key and click on it to open the godot documentation
func _unhandled_input(event: InputEvent) -> void:
	for action in inputs.keys():
		if event.is_action_pressed(action):
			move(action)

# We don't use _physics_process here because we just wait for a new input 
# to move instead of constantly check if there are keys being pressed

# Updates the direction of the RayCast2D according to the input key and moves one tile if no collision is detected
func move(action):
	var destination = inputs[action] * grid_size
	ray_cast_2d.target_position = destination
	ray_cast_2d.force_raycast_update()
	if not ray_cast_2d.is_colliding(): # Prevents to move if hitting a wall (tile with physics)
		position += destination

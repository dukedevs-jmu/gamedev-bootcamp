extends RigidBody2D

# Delete self on impact
func _on_body_entered(body):
	queue_free()

# If too far off screen, delete self.
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

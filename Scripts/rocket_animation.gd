extends AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_keys = ["thrust", "reverse"]
	
	# Play "thrust" if any movement key is just pressed
	for key in move_keys:
		if Input.is_action_just_pressed(key):
			play("thrust")
			break

	# Play "idle" if any movement key is just released
	for key in move_keys:
		if Input.is_action_just_released(key):
			play("idle")

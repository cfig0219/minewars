extends RigidBody2D

# private variables
var speed = 400
var rotation_speed = 3.0  # Radians per second


func _physics_process(delta):
	# Rotate left/right
	if Input.is_action_pressed("rotate_left"):  # A key
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("rotate_right"):  # D key
		rotation += rotation_speed * delta

	# Move forward in current direction
	if Input.is_action_pressed("thrust"):  # W key
		var forward = Vector2.UP.rotated(rotation)
		apply_central_force(forward * speed)
		
	# Move in reverse relative to current direction
	if Input.is_action_pressed("reverse"):  # S key
		var forward = Vector2.UP.rotated(rotation)
		apply_central_force(forward * (-1*speed))
		
		
	# Keys to store thrust and reverse move keys
	var move_keys = ["thrust", "reverse"]
	# Alters fuel and energy when thrust is applied
	for key in move_keys:
		if Input.is_action_just_pressed(key):
			
			# reduces fuel and energy per every throttle use
			Global.fuel = Global.fuel - (1/Global.fuel_mult)
			Global.energy = Global.energy - (1/Global.energy_mult)
			
			# sets minimum and maximum values for resources
			if Global.fuel > Global.fuel_max:
				Global.fuel = Global.fuel_max
			if Global.fuel < 0:
				Global.fuel = 0
			if Global.energy > Global.energy_max:
				Global.energy = Global.energy_max
			if Global.energy < 0:
				Global.energy = 0
			if Global.health < 0:
				Global.health = 0
			if Global.credits < 0:
				Global.credits = 0
			print(Global.credits)
			break

extends RigidBody2D

# variables accessible in the editor
@export var speed = 400
@export var rotation_speed = 3.0  # Radians per second

# private variables
var fuel_mult = 1.0
var energy_mult = 1.0


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
			Global.fuel = Global.fuel - (1/fuel_mult)
			Global.energy = Global.energy - (1/energy_mult)
			print(Global.fuel, " ", Global.energy)
			break

	# Optional: rotate to velocity direction (if needed)
	# (commented out, since you're now controlling rotation manually)
	# if linear_velocity.length() > 5.0:
	#     rotation = linear_velocity.angle() + deg_to_rad(90)

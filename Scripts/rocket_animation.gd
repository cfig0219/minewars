extends AnimatedSprite2D


# variable determines the animation based on current tier
var tier_frames = ["chemical", "nuclear", "fusion", "antimatter"]

func _ready() -> void:
	await get_tree().process_frame  # Wait one frame for Global to be set
	var default_animation = tier_frames[clamp(Global.tier - 1, 0, tier_frames.size() - 1)]
	animation = default_animation
	stop()
	frame = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var move_keys = ["thrust", "reverse"]

	var animation_name = tier_frames[clamp(Global.tier - 1, 0, tier_frames.size() - 1)]

	for key in move_keys:
		# if fuel is not zero
		if Global.fuel > 0:
			if Input.is_action_just_pressed(key):
				animation = animation_name
				stop()
				frame = 1  # "thrust" frame
				break

	for key in move_keys:
		if Input.is_action_just_released(key):
			animation = animation_name
			stop()
			frame = 0  # "idle" frame
			break

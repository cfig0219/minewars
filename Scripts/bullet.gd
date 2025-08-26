extends Node2D


# assigns an item number to determine values
@export_range(1, 4, 1) var item := 1
# Exported enum for friendly or enemy bullet in Inspector
@export_enum("friendly", "enemy") var bullet_type: String = "enemy"

# assigns values to each item number
var damage = {
	"bullet": 1,
	"plasma": 2,
	"missile": 6,
	"antimatter": 24
}

# assigns speed values to the bullets
var speed = {
	"bullet": 3,
	"plasma": 5,
	"missile": 3,
	"antimatter": 8
}

# Map item numbers to dictionary keys
var item_keys = ["bullet", "plasma", "missile", "antimatter"]
# Saves the x and y components of the current velocity
var x_velocity = 0.0
var y_velocity = 0.0
var player_dist = 0.0


func _ready():
	var area = $Area2D
	area.body_entered.connect(_on_area_entered)
	
	# alters the frame to display the correspinding item
	var sprite = $AnimatedSprite2D
	var key_name = item_keys[item - 1]
	sprite.animation = key_name
	
	# saves the x and y compoment of velocity during creation
	x_velocity = Global.velocity.x
	y_velocity = Global.velocity.y


func _process(_delta) -> void:
	var key_name = item_keys[item - 1]
	var speed_value = speed[key_name]
	
	# calculates the current velocity per frame rate
	var frame_vel = Vector2(x_velocity, y_velocity) * _delta
	# moves the projective in the current direction
	var forward = Vector2.UP.rotated(rotation + deg_to_rad(90))
	global_translate(frame_vel + (forward * speed_value))
	
	# Calculates distance from player
	player_dist = position.distance_to(Global.player_coordinates)
	if player_dist > 700:
		queue_free() # destroys bullet

# alters the current angle of the bullet
func set_angle(new_angle):
	rotation = new_angle - deg_to_rad(90)
	
# sets the item number / tier of the bullet
func set_tier(new_tier):
	item = new_tier
	
# sets the bullet type, must be either "friendly" or "enemy"
func set_type(new_type):
	bullet_type = new_type


func _on_area_entered(body):
	var key_name = item_keys[item - 1]  # Convert 1–4 to 0–3 index
	var dmg_value = damage[key_name]
	var body_name = body.name
	
	# alters value of health variables during interaction
	# if bullet is type enemy
	if bullet_type == "enemy":
		# if bullet collides with player
		if body_name == "Rocket":
			Global.health = Global.health - dmg_value
			# if bullet is not antimatter
			if item != 4:
				queue_free() # destroys object
	
	# if bullet is type friendly
	if bullet_type == "friendly":
		# if bullet collides with enemy
		if body_name == "Enemy":
			# if bullet is not antimatter
			if item != 4:
				queue_free() # destroys object
		# if bullet collides with asteriod
		if body_name == "Asteriod":
			#print(body.get_health())
			# if bullet is not antimatter
			if item != 4:
				queue_free() # destroys object

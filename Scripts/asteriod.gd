extends Node2D


# assigns an item number to determine values
@export_range(1, 4, 1) var item := 1

# assigns values to each item number
var damage = {
	"ice": 4,
	"rock": 6,
	"metal": 10,
}

# Map item numbers to dictionary keys
var item_keys = ["ice", "rock", "metal"]
var health = 4


func _ready():
	# connects child Area2D node to parent function
	var area = $Area2D
	area.body_entered.connect(_on_area_entered)
	# connects child Asteriod node
	
	# alters the frame to display the correspinding item
	var sprite = $AnimatedSprite2D
	var key_name = item_keys[item - 1]
	sprite.animation = key_name
	# alters the health value to correspond to damange value
	health = damage[key_name]

# sets the item number / tier of the bullet
func set_tier(new_tier):
	item = new_tier

func get_health():
	return health


func _on_area_entered(body):
	var key_name = item_keys[item - 1]  # Convert 1–4 to 0–3 index
	var dmg_value = damage[key_name]
	var body_name = body.name
	
	# if asteriod collides with player
	if body_name == "Rocket":
		Global.health = Global.health - dmg_value

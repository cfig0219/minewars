extends Node2D


# assigns an item number to determine values
@export_range(1, 4, 1) var item := 1

# assigns values to each item number
var damage = {
	"bullet": 1,
	"plasma": 2,
	"missile": 6,
	"antimatter": 24
}


# Map item numbers to dictionary keys
var item_keys = ["bullet", "plasma", "missile", "antimatter"]

func _ready():
	var area = $Area2D
	area.body_entered.connect(_on_area_entered)

func _on_area_entered(body):
	var key_name = item_keys[item - 1]  # Convert 1–4 to 0–3 index
	var dmg_value = damage[key_name]
	
	# alters value of global variables during interaction
	Global.health = Global.health - dmg_value
	print("Bullet collided with: ", body.name)

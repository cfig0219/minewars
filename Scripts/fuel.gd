extends Node2D


# assigns an item number to determine values
@export_range(1, 5, 1) var item := 1

var cash = {
	"water": 10,
	"petroleum": 30,
	"methane": 80,
	"oxygen": 130,
	"hydrogen": 2500
}

var fuel = {
	"water": 0.5,
	"petroleum": 1,
	"methane": 1,
	"oxygen": 2,
	"hydrogen": 4
}


# Map item numbers to dictionary keys
var item_keys = ["water", "petroleum", "methane", "oxygen", "hydrogen"]

func _ready():
	var area = $Area2D
	area.body_entered.connect(_on_area_entered)
	
	# alters the frame to display the correspinding item
	var sprite = $AnimatedSprite2D
	var key_name = item_keys[item - 1]
	sprite.animation = key_name


func _on_area_entered(_body):
	var key_name = item_keys[item - 1]  # Convert 1–4 to 0–3 index
	var fuel_value = fuel[key_name]
	var cash_value = cash[key_name]
	
	# alters value of global variables during interaction
	Global.fuel = Global.fuel + fuel_value
	Global.credits = Global.credits + cash_value
	queue_free() # destroys object

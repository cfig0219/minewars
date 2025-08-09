extends Node2D


# assigns an item number to determine values
@export_range(1, 15, 1) var item := 1

var cash = {
	"sulfur": 20,
	"coal": 50,
	"iron": 200,
	"aluminum": 400,
	"copper": 800,
	"lead": 1500,
	"titanium": 7000,
	"gold": 10000,
	"diamonds": 27000,
	"ice7": 40000,
	"tungsten": 120000,
	"neodymium": 210000,
	"osmium": 450000,
	"rhodium": 1800000,
	"plutonium": 5400000
}


# Map item numbers to dictionary keys
var item_keys = ["sulfur", "coal", "iron", "aluminum", "copper",
				"lead", "titanium", "gold", "diamonds", "ice7",
				"tungsten", "neodymium", "osmium", "rhodium", "plutonium"]

func _ready():
	var area = $Area2D
	area.body_entered.connect(_on_area_entered)

func _on_area_entered(body):
	var key_name = item_keys[item - 1]  # Convert 1–4 to 0–3 index
	var cash_value = cash[key_name]
	
	# alters value of global variables during interaction
	Global.credits = Global.credits + cash_value
	print("Item collided with: ", body.name)

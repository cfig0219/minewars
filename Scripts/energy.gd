extends Node2D


# assigns an item number to determine values
@export_range(1, 5, 1) var item := 1

var cash = {
	"lithium": 4500,
	"uranium": 18000,
	"deuterium": 75000,
	"tritium": 32400000,
	"antimatter": 270000000
}

var energy = {
	"lithium": 10,
	"uranium": 10,
	"deuterium": 10,
	"tritium": 40,
	"antimatter": 120
}


# Map item numbers to dictionary keys
var item_keys = ["lithium", "uranium", "deuterium", "tritium", "antimatter"]

func _ready():
	var area = $Area2D
	area.body_entered.connect(_on_area_entered)

func _on_area_entered(body):
	var key_name = item_keys[item - 1]  # Convert 1–4 to 0–3 index
	var eng_value = energy[key_name]
	var cash_value = cash[key_name]
	
	# alters value of global variables during interaction
	Global.energy = Global.energy - eng_value
	Global.credits = Global.credits + cash_value
	print("Energy collided with: ", body.name)

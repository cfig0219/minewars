extends Node2D

# assigns an item number to determine values
@export_range(1, 6, 1) var item := 1


# Map item numbers to dictionary keys
var item_keys = ["cloud1", "cloud2", "cloud3",
				 "cloud4", "cloud5", "cloud6"]

func _ready():
	# alters the frame to display the correspinding item
	var sprite = $AnimatedSprite2D
	var key_name = item_keys[item - 1]
	sprite.animation = key_name

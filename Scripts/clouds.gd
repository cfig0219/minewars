extends Node2D

# assigns an item number to determine values
@export_range(1, 6, 1) var item := 1
# --- Custom cloud color (RGB) ---
@export var cloud_color: Color = Color(1, 1, 1) # Default white (no tint)

# stores a list of the current planet's resources
var planet_resources = []
# Map item numbers to dictionary keys
var item_keys = ["cloud1", "cloud2", "cloud3",
				 "cloud4", "cloud5", "cloud6"]


var gem_times = {
	"sulfur": 15,
	"coal": 20,
	"iron": 30,
	"aluminum": 35,
	"copper": 40,
	"lead": 50,
	"titanium": 70,
	"gold": 80,
	"diamonds": 100,
	"ice7": 110,
	"tungsten": 160,
	"neodymium": 210,
	"osmium": 250,
	"rhodium": 380,
	"plutonium": 540
}

var fuel_times = {
	"water": 10,
	"petroleum": 17,
	"methane": 23,
	"oxygen": 26,
	"hydrogen": 60
}

var energy_times = {
	"lithium": 65,
	"uranium": 90,
	"deuterium": 130,
	"tritium": 750,
	"antimatter": 1000
}


func _ready():
	# alters the frame to display the correspinding item
	var sprite = $AnimatedSprite2D
	var key_name = item_keys[item - 1]
	sprite.animation = key_name
	
	# Apply color tint to planet texture
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.modulate = cloud_color
		
	# connect Area2D collision signal
	$Area2D.body_entered.connect(_on_area_entered)

# Returns all matching planet resources that exist in the given map
func get_matching_resources_from_map(resource_map: Dictionary) -> Array:
	var matches: Array = []
	for res in planet_resources:
		if res in resource_map:
			matches.append(res)
	return matches


# Spawns an energy scene instance if energy is found
func spawn_energy_resource():
	var energy_scene = preload("res://Scenes/Resources/energy.tscn").instantiate()
	get_tree().current_scene.add_child(energy_scene)
	
	# Random offset between -50 and 50 for both x and y
	var offset_x = randf_range(-50, 50)
	var offset_y = randf_range(-50, 50)
	energy_scene.global_position = global_position + Vector2(offset_x, offset_y)

# Spawns an fuel scene instance if fuel is found
func spawn_fuel_resource():
	var fuel_scene = preload("res://Scenes/Resources/fuel.tscn").instantiate()
	get_tree().current_scene.add_child(fuel_scene)
	
	# Random offset between -50 and 50 for both x and y
	var offset_x = randf_range(-50, 50)
	var offset_y = randf_range(-50, 50)
	fuel_scene.global_position = global_position + Vector2(offset_x, offset_y)

# Spawns a gems scene instance if a gem is found
func spawn_gem_resource():
	var gem_scene = preload("res://Scenes/Resources/gems.tscn").instantiate()
	get_tree().current_scene.add_child(gem_scene)
	
	# Random offset between -50 and 50 for both x and y
	var offset_x = randf_range(-50, 50)
	var offset_y = randf_range(-50, 50)
	gem_scene.global_position = global_position + Vector2(offset_x, offset_y)


# Called when another physics body enters our Area2D
func _on_area_entered(body):
	if body.scene_file_path.ends_with("planet.tscn"):
		
		# Check if the planet has a script and the property exists
		if body.get_script() != null and "selected_resources" in body:
			planet_resources = body.selected_resources
			
	var found_gems = get_matching_resources_from_map(gem_times)
	var found_fuel = get_matching_resources_from_map(fuel_times)
	var found_energy = get_matching_resources_from_map(energy_times)
	
	# spawns resources if resources are found
	if found_energy.size() > 0:
		call_deferred("spawn_energy_resource") # deferrs call to prevent error
	if found_fuel.size() > 0:
		call_deferred("spawn_fuel_resource")
	if found_gems.size() > 0:
		call_deferred("spawn_gem_resource")

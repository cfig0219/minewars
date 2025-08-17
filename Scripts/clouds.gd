extends Node2D


# assigns an item number to determine values
@export_range(1, 6, 1) var item := 1
# --- Custom cloud color (RGB) ---
@export var cloud_color: Color = Color(1, 1, 1) # Default white (no tint)
# Map item numbers to dictionary keys
var item_keys = ["cloud1", "cloud2", "cloud3",
				 "cloud4", "cloud5", "cloud6"]

# stores a list of the current planet's resources
var planet_resources = []
var found_fuel = []
var found_energy = []


var fuel_times = {
	"water": 10,
	"petroleum": 12,
	"methane": 14,
	"oxygen": 16,
	"hydrogen": 26
}

var energy_times = {
	"lithium": 29,
	"uranium": 42,
	"deuterium": 53,
	"tritium": 211,
	"antimatter": 441
}

# Timer to control spawn intervals
var spawn_timer := 0.0
var spawn_interval := 5.0
var spawn_loop_active := false


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
func spawn_energy_resource(item: int):
	var energy_scene = preload("res://Scenes/Resources/energy.tscn").instantiate()
	energy_scene.set_item(item) # alters the resource by item number
	get_tree().current_scene.add_child(energy_scene)
	
	# Random offset between -50 and 50 for both x and y
	var offset_x = randf_range(-50, 50)
	var offset_y = randf_range(-50, 50)
	energy_scene.global_position = global_position + Vector2(offset_x, offset_y)

# Spawns an fuel scene instance if fuel is found
func spawn_fuel_resource(item: int):
	var fuel_scene = preload("res://Scenes/Resources/fuel.tscn").instantiate()
	fuel_scene.set_item(item) # alters the resource by item number
	get_tree().current_scene.add_child(fuel_scene)
	
	# Random offset between -50 and 50 for both x and y
	var offset_x = randf_range(-50, 50)
	var offset_y = randf_range(-50, 50)
	fuel_scene.global_position = global_position + Vector2(offset_x, offset_y)


# Called when another physics body enters our Area2D
func _on_area_entered(body):
	if body.scene_file_path.ends_with("planet.tscn"):
		
		# Check if the planet has a script and the property exists
		if body.get_script() != null and "selected_resources" in body:
			planet_resources = body.selected_resources
			
	found_fuel = get_matching_resources_from_map(fuel_times)
	found_energy = get_matching_resources_from_map(energy_times)
		
	if found_fuel.size() > 0 or found_energy.size() > 0:
			spawn_loop_active = true
			spawn_timer = 0.0  # reset timer

func _process(delta):
	if spawn_loop_active:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0.0
			call_spawn_functions()


# Returns the index of a resource key in a given map (or -1 if not found)
func get_resource_index(resource_name: String, resource_map: Dictionary) -> int:
	var keys = resource_map.keys()
	var idx = keys.find(resource_name)
	return idx if idx != -1 else -1

func call_spawn_functions():
	# variables to store a list of resource item numbers
	var energy_items = []
	var fuel_items = []
	
	# obtains the item numbers of the found resources
	for energy in found_energy:
		var energy_index = 1 + get_resource_index(energy, energy_times)
		spawn_energy_resource(energy_index)
		print(energy_index, energy)
	for fuel in found_fuel:
		var fuel_index = 1 + get_resource_index(fuel, fuel_times)
		spawn_fuel_resource(fuel_index)
		print(fuel_index, fuel)

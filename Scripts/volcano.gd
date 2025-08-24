extends Node2D


# assigns an item number to determine values
@export_range(1, 3, 1) var item := 1
# Map item numbers to dictionary keys
var item_keys = ["ice", "dormant", "active"]

# stores a list of the current planet's resources
var planet_resources = []
var found_gems = []
var found_fuel = []
var found_energy = []


var gem_times = {
	"sulfur": 11,
	"coal": 13,
	"iron": 17,
	"aluminum": 19,
	"copper": 22,
	"lead": 24,
	"titanium": 31,
	"gold": 36,
	"diamonds": 45,
	"ice7": 49,
	"tungsten": 59,
	"neodymium": 71,
	"osmium": 90,
	"rhodium": 113,
	"plutonium": 142
}

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
func spawn_energy_resource(selected: int):
	var energy_scene = preload("res://Scenes/Resources/energy.tscn").instantiate()
	energy_scene.set_item(selected) # alters the resource by item number
	get_tree().current_scene.add_child(energy_scene)
	
	# Random offset between -50 and 50 for both x and y
	var offset_x = randf_range(-50, 50)
	var offset_y = randf_range(-50, 50)
	energy_scene.global_position = global_position + Vector2(offset_x, offset_y)

# Spawns an fuel scene instance if fuel is found
func spawn_fuel_resource(selected: int):
	var fuel_scene = preload("res://Scenes/Resources/fuel.tscn").instantiate()
	fuel_scene.set_item(selected) # alters the resource by item number
	get_tree().current_scene.add_child(fuel_scene)
	
	# Random offset between -50 and 50 for both x and y
	var offset_x = randf_range(-50, 50)
	var offset_y = randf_range(-50, 50)
	fuel_scene.global_position = global_position + Vector2(offset_x, offset_y)

# Spawns a gems scene instance if a gem is found
func spawn_gem_resource(selected: int):
	var gem_scene = preload("res://Scenes/Resources/gems.tscn").instantiate()
	gem_scene.set_item(selected) # alters the resource by item number
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
			
	found_gems = get_matching_resources_from_map(gem_times)
	found_fuel = get_matching_resources_from_map(fuel_times)
	found_energy = get_matching_resources_from_map(energy_times)
		
	if found_fuel.size() > 0 or found_gems.size() > 0 or found_energy.size() > 0:
			spawn_loop_active = true
			spawn_timer = 0.0  # reset timer


# Returns the index of a resource key in a given map (or -1 if not found)
func get_resource_index(resource_name: String, resource_map: Dictionary) -> int:
	var keys = resource_map.keys()
	var idx = keys.find(resource_name)
	return idx if idx != -1 else -1

# Returns the spawn time of a resource from the given map.
func get_spawn_time(resource_name: String, resource_map: Dictionary) -> int:
	if resource_map.has(resource_name):
		return resource_map[resource_name]
	else:
		return -1  # return -1 if not found

# Dictionary to keep track of per-resource timers
var resource_timers: Dictionary = {}

func _process(delta):
	if spawn_loop_active:
		# Update timers for each found resource
		update_spawn_timers(delta)


func update_spawn_timers(delta):
	# Handle energy
	for energy in found_energy:
		if not resource_timers.has(energy):
			resource_timers[energy] = 0.0
		resource_timers[energy] += delta

		var spawn_time = get_spawn_time(energy, energy_times)
		if resource_timers[energy] >= spawn_time:
			resource_timers[energy] = 0.0
			var idx = 1 + get_resource_index(energy, energy_times)
			spawn_energy_resource(idx)
			#print("Spawned", energy, "every", spawn_time, "seconds")

	# Handle fuel
	for fuel in found_fuel:
		if not resource_timers.has(fuel):
			resource_timers[fuel] = 0.0
		resource_timers[fuel] += delta

		var spawn_time = get_spawn_time(fuel, fuel_times)
		if resource_timers[fuel] >= spawn_time:
			resource_timers[fuel] = 0.0
			var idx = 1 + get_resource_index(fuel, fuel_times)
			spawn_fuel_resource(idx)
			#print("Spawned", fuel, "every", spawn_time, "seconds")

	# Handle gems
	for gem in found_gems:
		if not resource_timers.has(gem):
			resource_timers[gem] = 0.0
		resource_timers[gem] += delta

		var spawn_time = get_spawn_time(gem, gem_times)
		if resource_timers[gem] >= spawn_time:
			resource_timers[gem] = 0.0
			var idx = 1 + get_resource_index(gem, gem_times)
			spawn_gem_resource(idx)
			#print("Spawned", gem, "every", spawn_time, "seconds")

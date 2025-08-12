extends StaticBody2D


# Exported enum for planet type selection in Inspector
@export_enum("rocky", "gas", "star") var planet_type: String = "rocky"
# --- Custom planet color (RGB) ---
@export var planet_color: Color = Color(1, 1, 1) # Default white (no tint)

# --- Resource selection using bitmask flags ---
@export_flags("water", "sulfur", "petroleum", "coal", "methane",
			  "oxygen", "iron", "aluminum", "copper", "lead",
			  "hydrogen", "lithium", "titanium", "gold", "uranium",
			  "diamonds", "ice7", "deuterium", "tungsten", "neodymium",
			  "osmium", "rhodium", "plutonium", "tritium", "antimatter") var resources: int = 0

# Corresponding resource list
var resource_names = ["water", "sulfur", "petroleum", "coal", "methane",
			"oxygen", "iron", "aluminum", "copper", "lead",
			"hydrogen", "lithium", "titanium", "gold", "uranium",
			"diamonds", "ice7", "deuterium", "tungsten", "neodymium",
			"osmium", "rhodium", "plutonium", "tritium", "antimatter"]
var selected_resources = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(resource_names.size()):
		if resources & (1 << i):
			selected_resources.append(resource_names[i])
	
	# Apply color tint to planet texture
	if has_node("Sprite2D"):
		$Sprite2D.modulate = planet_color

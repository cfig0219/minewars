extends Node2D


# variables accessible in the editor
@export_range(1, 4, 1) var tier := 1

# private variables
var fuel_mult = 1.0
var energy_mult = 1.0
var health = 3.0


# determines the fuel, energy, and health based on current tier
func _ready() -> void:
	if tier == 1:
		fuel_mult = 1.0
		energy_mult = 1.0
		health = 3.0
		
	if tier == 2:
		fuel_mult = 2.0
		energy_mult = 4.0
		health = 9.0
		
	if tier == 3:
		fuel_mult = 8.0
		energy_mult = 32.0
		health = 27.0
		
	if tier == 4:
		fuel_mult = 96.0
		energy_mult = 1152.0
		health = 81.0
		

	# modifies global variables to match those of player
	Global.fuel_mult = fuel_mult
	Global.energy_mult = energy_mult
	Global.health = health
	Global.health_max = health
	Global.tier = tier
	
func _process(_delta) -> void:
	# destroys rocket if health is zero or less
	if Global.health <= 0:
		queue_free()

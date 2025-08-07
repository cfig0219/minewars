extends Node2D


# variables accessible in the editor
@export var fuel_mult = 1.0
@export var energy_mult = 1.0
@export var health = 3.0

# modifies global variables to match those of player
func _ready() -> void:
	Global.fuel_mult = fuel_mult
	Global.energy_mult = energy_mult
	Global.health = health

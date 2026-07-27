class_name Weapon
extends Node2D

@export var firing_range := 50
@export_range(-360.0, 360.0, 1.0, 'degrees') var firing_radius := 45

func setup(ship_res: ShipResource) -> void:
	$firing_range.setup(ship_res, firing_range, firing_radius)


func _on_firing_range_fire(_pos: Vector2) -> void:
	$FX.restart()

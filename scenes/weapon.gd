class_name Weapon
extends Node2D

@export var firing_range := 50
@export_range(-360.0, 360.0, 1.0, 'degrees') var firing_radius := 45

var targets_in_range: Array[Spaceship]
var is_reloading := false


func setup(ship_res: ShipResource) -> void:
	$firing_range.setup(ship_res, firing_range, firing_radius, targets_in_range)


func _on_first_target_in_range() -> void:
	fire(targets_in_range[0])


func fire(_ship: Spaceship) -> void:
	$FX.restart()
	$Timers/ReloadTimer.start()
	is_reloading = true


func _on_reload_timer_timeout() -> void:
	is_reloading = false
	check_for_targets()


func check_for_targets() -> void:
	if targets_in_range.is_empty(): return
	pick_target()


func pick_target() -> void:
	fire(targets_in_range[0])

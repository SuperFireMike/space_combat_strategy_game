class_name Weapon
extends Node2D

@export var firing_range := 50
@export_range(-360.0, 360.0, 1.0, 'degrees') var firing_radius := 45
@export_range(0.2, 200000, 0.1, "suffix:s") var reload_time := 1.5

var targets_in_range: Array[Spaceship]
var is_reloading := false

var projectile_scene := preload("res://scenes/projectile.tscn")

var parent_ship: Spaceship

func setup(ship: Spaceship) -> void:
	parent_ship = ship
	$firing_range.setup(ship.res, firing_range, firing_radius, targets_in_range)


func _on_first_target_in_range() -> void:
	fire(targets_in_range[0])


func fire(ship: Spaceship) -> void:
	$FX.restart()
	$Timers/ReloadTimer.start()
	is_reloading = true
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.setup(self, parent_ship, 1, 500, global_position.direction_to(ship.global_position))
	(get_tree().current_scene as Level).new_projectile(projectile)


func _on_reload_timer_timeout() -> void:
	is_reloading = false
	check_for_targets()


func check_for_targets() -> void:
	if targets_in_range.is_empty(): return
	pick_target()


func pick_target() -> void:
	fire(targets_in_range[0])


func _ready() -> void:
	$Timers/ReloadTimer.wait_time = reload_time

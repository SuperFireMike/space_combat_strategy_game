class_name FiringRange
extends Area2D

signal target_in_range()

var ship_res: ShipResource
var target: Spaceship = null
var ready_to_fire := true

var targets_in_range: Array[Spaceship]

func setup(res: ShipResource, firing_range: int, firing_radius: float, targets_array: Array[Spaceship]) -> void:
	ship_res = res
	targets_in_range = targets_array
	change_range(firing_range, firing_radius)


func _on_body_entered(ship: Spaceship) -> void:
	if ship_res.faction != ship.res.faction:
		targets_in_range.append(ship)
		if targets_in_range.size() == 1 and not (get_parent() as Weapon).is_reloading:
			target_in_range.emit()


func _on_body_exited(ship: Spaceship) -> void:
	if ship_res.faction != ship.res.faction:
		targets_in_range.erase(ship)


func change_range(firing_range: int, firing_radius: float) -> void:
	var points := PackedVector2Array()
	points.append(Vector2.ZERO)
	
	var spread := deg_to_rad(firing_radius)
	var direction_offset := -PI / 2
	var start_angle := direction_offset - spread / 2
	var end_angle := direction_offset + spread / 2
	
	var arc_len := firing_range * spread
	
	var target_segment_len: float = 25
	var raw_resolution := int(arc_len / target_segment_len)
	var resolution := clampi(raw_resolution, 3, 64)
	
	var angle_step := (end_angle - start_angle) / resolution
	
	for i in range(resolution + 1):
		var cur_angle := start_angle + i * angle_step
		var x := int(cos(cur_angle) * firing_range)
		var y := int(sin(cur_angle) * firing_range)
		points.append(Vector2(x, y))
	
	$CollisionPolygon2D.polygon = points

class_name FiringRange
extends Area2D

signal fire(pos: Vector2)

var ship_res: ShipResource
var target: Spaceship = null
var ready_to_fire := true


func setup(res: ShipResource, firing_range: int, firing_radius: float) -> void:
	ship_res = res
	change_range(firing_range, firing_radius)


func _on_body_entered(body: Node2D) -> void:
	if body is not Spaceship: return
	var ship := body as Spaceship
	if ship_res.faction != ship.res.faction:
		target = ship
		signal_fire()


func _on_reload_timer_timeout() -> void:
	if target:
		signal_fire()


func signal_fire() -> void:
	if not ready_to_fire: return
	fire.emit(target.global_position)
	$Timers/ReloadTimer.start()


func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


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

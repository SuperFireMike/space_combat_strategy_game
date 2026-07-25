class_name FiringRange
extends Area2D


signal fire(pos: Vector2)

var ship_res: ShipResource
var target: Spaceship = null
var ready_to_fire := true


func setup(res: ShipResource, firing_range: CollisionPolygon2D) -> void:
	$CollisionPolygon2D.polygon = firing_range.polygon
	ship_res = res
	firing_range.queue_free()


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

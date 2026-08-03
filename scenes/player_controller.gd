extends ShipController


func _physics_process(delta: float) -> void:
	get_input()


func get_input() -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	direction = -dir.y
	rotation = dir.x

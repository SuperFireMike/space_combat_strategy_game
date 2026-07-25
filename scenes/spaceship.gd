class_name Spaceship
extends CharacterBody2D


@export var speed := 300
@export var rotation_speed := 3

var direction: Vector2
var destination: Vector2
var mouse_in_range := false
var selected := false
var acting := false

@export var res: ShipResource


func _physics_process(delta: float) -> void:
	get_input()
	velocity = direction * speed
	if acting: act(delta)
	move_and_slide()


func get_input() -> void:
	if mouse_in_range and Input.is_action_just_pressed("select"):
		selected = not selected
	if Input.is_action_just_pressed("action") and selected:
		destination = get_global_mouse_position()
		acting = true


func _on_mouse_entered() -> void:
	mouse_in_range = true


func _on_mouse_exited() -> void:
	mouse_in_range = false


func act(delta: float) -> void:
	if position.distance_to(destination) <= 20:
			acting = false
			direction = Vector2.ZERO
	else:
		var target_angle = global_position.angle_to_point(destination)
		global_rotation = lerp_angle(global_rotation, target_angle, rotation_speed * delta)
		direction = Vector2.from_angle(global_rotation)


func _ready() -> void:
	$firing_range.setup(res, $CollisionPolygon2D)


func _on_firing_range_fire(pos: Vector2) -> void:
	print("Fire %s" % [pos])

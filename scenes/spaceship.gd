class_name Spaceship
extends CharacterBody2D

@export var speed := 300
@export var turn_speed: float = 3
@export var stopping_speed: float = 700
@export var full_hp := 3

@export var controller: ShipController

var direction: Vector2
var destination: Vector2
var mouse_in_range := false
var selected := false
var acting := false

@export var res: ShipResource


func _physics_process(delta: float) -> void:
	rotation += controller.rotation * turn_speed * delta
	var forward_dir := transform.x
	if controller.direction:
		velocity = forward_dir * controller.direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, stopping_speed * delta)
	#if acting: act(delta)
	move_and_slide()


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
		global_rotation = lerp_angle(global_rotation, target_angle, turn_speed * delta)
		direction = Vector2.from_angle(global_rotation)


func _ready() -> void:
	for weapon: Weapon in $Weapons.get_children():
		weapon.setup(self)
	res.health_component = $HealthComponent
	$HealthComponent.max_hp = full_hp


func get_destroyed() -> void:
	queue_free()


func hit(hp: int) -> void:
	$HealthComponent.cur_hp -= hp

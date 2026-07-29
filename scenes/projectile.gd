class_name Projectile
extends Area2D

var damage := 1
var speed := 200 
var direction: Vector2

var parent_ship: Spaceship

func _on_body_entered(body: Node2D) -> void:
	if "hit" in body and (body as Spaceship) != parent_ship:
		body.hit(damage)
		queue_free()


func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta


@warning_ignore("shadowed_variable")
func setup(weapon: Weapon, ship: Spaceship, damage: int = 1, speed: int = 500, direction: Vector2 = Vector2.RIGHT) -> void:
	self.damage = damage
	self.speed = speed
	self.direction = direction
	parent_ship = ship
	global_position = weapon.global_position

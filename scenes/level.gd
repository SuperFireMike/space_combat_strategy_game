class_name Level
extends Node2D

func new_projectile(projectile: Projectile) -> void:
	call_deferred("_add_projectile", projectile)


func _add_projectile(projectile: Projectile) -> void:
	$Objects.add_child(projectile)

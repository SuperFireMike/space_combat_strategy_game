class_name HealthComponent
extends Node

signal die()

@export var max_hp: int:
	set(hp):
		max_hp = hp
		cur_hp = hp
var cur_hp: int:
	set(hp):
		if hp <= 0:
			die.emit()
		else:
			cur_hp = hp


func _ready() -> void:
	cur_hp = max_hp

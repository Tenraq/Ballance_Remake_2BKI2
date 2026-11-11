extends Node3D


@export var power:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for parts:RigidBody3D in self.get_children():
		parts.gravity_scale = 0.6
		parts.apply_impulse(parts.get_child(0).position * power, self.global_position)
	
	
	await get_tree().create_timer(5).timeout
	queue_free()

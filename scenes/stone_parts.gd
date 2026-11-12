extends Node3D

@export var power:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power = randf_range(0.8, 1.2)
	for parts:RigidBody3D in self.get_children():
		parts.mass = 1
		parts.set_collision_mask_value(2, true)
		parts.apply_impulse(parts.get_child(0).position * power, self.global_position)
		
	await get_tree().create_timer(5).timeout
	queue_free()

extends Node3D

@export var power:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power = randf_range(2.5, 2.5)
	for parts:RigidBody3D in self.get_children():
		parts.mass = 1
		parts.gravity_scale = 1.3
		#parts.set_collision_mask_value(2, false)
		parts.apply_impulse(parts.get_child(0).position * power, self.global_position)
		
	await get_tree().create_timer(5).timeout
	queue_free()

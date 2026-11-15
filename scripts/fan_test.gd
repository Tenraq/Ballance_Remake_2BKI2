extends Node3D
@onready var detector: Area3D = $detector




func _on_detector_body_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		body.over_fan -= 1

func _on_detector_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.over_fan += 1

extends Node3D
@onready var detector: Area3D = $detector
func _process(delta: float) -> void:
	detector.get_overlapping_bodies()




func _on_detector_body_exited(body: Node3D) -> void:
	pass # Replace with function body.


func _on_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.apply_central_force()

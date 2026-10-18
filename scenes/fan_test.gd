extends Node3D
@onready var detector: Area3D = $detector




func _on_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.over_fan = false


func _on_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.over_fan = true

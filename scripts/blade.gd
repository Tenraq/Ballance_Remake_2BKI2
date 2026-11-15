extends Node3D
@onready var killzone: Area3D = $killzone


# Called when the node enters the scene tree for the first time.



func _on_killzone_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass# Replace with function body.

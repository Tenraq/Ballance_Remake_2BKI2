extends MeshInstance3D
var speed: float =0.01
@onready var directional_light_3d: DirectionalLight3D = $"../DirectionalLight3D"

func _process(delta: float) -> void:
	global_rotation.y = global_rotation.y + delta * speed
	directional_light_3d.global_rotation.y = directional_light_3d.global_rotation.y + delta * speed

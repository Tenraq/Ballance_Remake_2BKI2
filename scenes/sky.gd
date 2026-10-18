extends MeshInstance3D
var speed: float =0.015
@onready var directional_light_3d: DirectionalLight3D = $"../DirectionalLight3D"
@onready var label: Label = $"../Label"
@onready var animplayer: AnimationPlayer = $"../WorldEnvironment/animplayer"

func _process(_delta: float) -> void:
	#global_rotation.y = global_rotation.y + delta * speed
	#directional_light_3d.global_rotation.y = directional_light_3d.global_rotation.y + delta * speed
	label.text ="FPS " + str(Engine.get_frames_per_second())

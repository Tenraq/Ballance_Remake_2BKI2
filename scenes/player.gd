extends RigidBody3D
@onready var camera: Camera3D = $Node3D/Camera
#test test
var views_index = 0
@onready var camera_holder: Node3D = $Node3D



var speed = 8
@export var camera_follow_speed:float
var pressed:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	var input = Vector3.ZERO
	input.x = Input.get_axis("A","D")
	input.z = Input.get_axis("W", "S")
	var dir = camera_holder.basis * input
	dir.y = 0
	dir = dir.normalized()
	linear_velocity = linear_velocity.limit_length(10)
	apply_central_force(dir * speed)
	camera_holder.global_position = camera_holder.global_position.lerp(global_position, camera_follow_speed * delta)
	camera.look_at(camera_holder.global_position)
	if Input.is_action_just_pressed("Q"):
		camera_rotate(-90)
	elif Input.is_action_just_pressed("E"):
		camera_rotate(90)
	print(linear_velocity)
func camera_rotate(amount: int):
	if pressed == false:
		pressed = true
		var tween = get_tree().create_tween()
		tween.tween_property(camera_holder, "global_rotation:y", camera_holder.global_rotation.y + deg_to_rad(amount), 0.3)
		await tween.finished
		pressed = false

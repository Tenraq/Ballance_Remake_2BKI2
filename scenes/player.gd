extends RigidBody3D
@onready var camera: Camera3D = $Node3D/Camera
@onready var camera_holder: Node3D = $Node3D

#collisionen
@onready var collision_ball_node: CollisionShape3D = $collision_ball
@onready var collision_ball_shapes = [
	preload("res://MDLS/ball_meshe/paper_collison.tres"), 
	preload("res://MDLS/ball_meshe/normal_collison.tres")
	] 


#ball Arten:
@onready var ball_meshes: Array[ArrayMesh] = [
	preload("res://MDLS/ball_meshe/wood_mesh.tres"), 
	preload("res://MDLS/ball_meshe/stone_mesh.tres"),
	preload("res://MDLS/ball_meshe/paper_mesh.tres")
	]
@onready var ball_model: MeshInstance3D = $ball_model
var current_ball: BallTypes.types
var cycle = 0
var respawn: Vector3
var speed = 12

@export var camera_follow_speed:float
var pressed:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_ball = BallTypes.types.wood
	print("git?")
	respawn = global_position
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input = Vector3.ZERO
	input.x = Input.get_axis("A","D")
	input.z = Input.get_axis("W", "S")
	var dir = camera_holder.basis * input
	dir.y = 0
	dir = dir.normalized()
	#linear_velocity = linear_velocity.limit_length(20)
	apply_central_force(dir * speed)
	camera_holder.global_position = camera_holder.global_position.lerp(global_position, camera_follow_speed * delta)
	camera.look_at(camera_holder.global_position)
	if Input.is_action_just_pressed("Q"):
		camera_rotate(90)
	elif Input.is_action_just_pressed("E"):
		camera_rotate(-90)
	elif Input.is_action_just_pressed("ui_accept"):
		global_position = respawn
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
	elif Input.is_action_just_pressed("G"):
		cycle = cycle + 1
		if cycle > 2:
			cycle = 0
		if cycle == 0:
			ballSwitch(BallTypes.types.wood)
		if cycle == 1:
			ballSwitch(BallTypes.types.stone)
		if cycle == 2:
			ballSwitch(BallTypes.types.paper)
	print(linear_velocity)



func camera_rotate(amount: int):
	if pressed == false:
		pressed = true
		var tween = get_tree().create_tween()
		tween.tween_property(camera_holder, "global_rotation:y", camera_holder.global_rotation.y + deg_to_rad(amount), 0.15)
		await tween.finished
		pressed = false

func ballSwitch(typeTo: BallTypes.types):
	if typeTo == BallTypes.types.wood:
		
		
		speed = 10
		gravity_scale = 1.3
		linear_damp = 1.7
		angular_damp = 0.2
		mass = 1
		#---------------------------------
		
		
		#--------Visuelle Elemente--------
		ball_model.mesh = ball_meshes[0]
		collision_ball_node.shape = collision_ball_shapes[1]
		collision_ball_node.scale = Vector3(0.84,0.84,0.84)
		#---------------------------------
		
	elif typeTo == BallTypes.types.stone:
		
		
		speed = 19
		gravity_scale = 1.5
		linear_damp = 0.7
		angular_damp = 0.2
		mass = 5
		#---------------------------------
		
		
		#--------Visuelle Elemente--------
		ball_model.mesh = ball_meshes[1]
		collision_ball_node.shape = collision_ball_shapes[1]
		collision_ball_node.scale = Vector3(0.84,0.84,0.84)
		#---------------------------------
		
	elif typeTo == BallTypes.types.paper:
		
		
		speed = 4
		gravity_scale = 0.9
		linear_damp = 2.3
		angular_damp = 0.2
		mass = 0.3
		#---------------------------------
		
		
		#--------Visuelle Elemente--------
		ball_model.mesh = ball_meshes[2]
		collision_ball_node.shape = collision_ball_shapes[0]
		collision_ball_node.scale = Vector3(0.42,0.42,0.42)
		#---------------------------------

#-----------------------------------------Variablen-----------------------------------------

extends RigidBody3D
@onready var camera: Camera3D = $"camera holder/Camera"
@onready var camera_holder: Node3D = $"camera holder"
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
var animationplayer: AnimationPlayer
@onready var deathscreen: ColorRect = $UI/deathscreen
@onready var u_ianims: AnimationPlayer = $UI/UIanims

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
var speed = 10

@export var camera_follow_speed:float
var pressed:bool = false

var cam_y_position
var fell = false
var over_fan = false
var ball_alive = true
var can_control_player = true
var lives = 1
@onready var lives_UI: Label = $UI/lives

func _ready() -> void:
	current_ball = BallTypes.types.wood
	print("git?")
	respawn = global_position
	animationplayer = get_tree().root.find_child("animplayer", true, false)
	print(animationplayer)
	lives_UI.text = "Lives: " + str(lives)

#-----------------------------------------physics_process-----------------------------------------
func _physics_process(delta: float) -> void:
	if can_control_player:
		var input = Vector3.ZERO
		input.x = Input.get_axis("A","D")
		input.z = Input.get_axis("W", "S")
		var dir = camera_holder.basis * input
		dir.y = 0
		dir = dir.normalized()
	#linear_velocity = linear_velocity.limit_length(20)
		apply_central_force(dir * speed)
		if Input.is_action_just_pressed("Q"):
			camera_rotate(90)
		elif Input.is_action_just_pressed("E"):
			camera_rotate(-90)
		if Input.is_action_pressed("ui_accept"):
			camera.position = camera.position.lerp(Vector3(0,7,1.848),5 * delta)
		else:
			camera.position = camera.position.lerp(Vector3(0,2.33,1.848),5 * delta)
	else:
		fall_cam(camera.global_position.y)
		camera.global_position.y = cam_y_position
	
	
	if over_fan:
		apply_central_force(Vector3(0,randf_range(2,6),0))
	
	
	camera_holder.global_position = camera_holder.global_position.lerp(global_position, camera_follow_speed * delta)
	
	camera.look_at(camera_holder.position)
	
	if Input.is_action_just_pressed("G"):
		cycle = cycle + 1
		if cycle > 2:
			cycle = 0
		if cycle == 0:
			ballSwitch(BallTypes.types.wood)
		if cycle == 1:
			ballSwitch(BallTypes.types.stone)
		if cycle == 2:
			ballSwitch(BallTypes.types.paper)
	
	
	
	if ball_alive == true:
		if global_position.y < -10:
			ball_alive = false
			if lives > 0:
				axis_lock_linear_x = true
				axis_lock_linear_z = true
				animationplayer.play("fail")
				await animationplayer.animation_finished
				deathscreen.show()
				global_position = respawn
				await  get_tree().create_timer(1).timeout
				deathscreen.hide()
				ball_alive = true
				animationplayer.play_backwards("fail")
				lives -= 1
				lives_UI.text = "Lives: " + str(lives)
				axis_lock_linear_x = false
				axis_lock_linear_z = false
			else:
				can_control_player = false



#-----------------------------------------camera_rotate-----------------------------------------
func camera_rotate(amount: int):
	if pressed == false:
		pressed = true
		var tween = get_tree().create_tween()
		tween.tween_property(camera_holder, "global_rotation:y", camera_holder.global_rotation.y + deg_to_rad(amount), 0.15)
		await tween.finished
		pressed = false


#-----------------------------------------ballSwitch-----------------------------------------
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
		gravity_scale = 1.0
		linear_damp = 2.0
		angular_damp = 0.2
		mass = 0.3
		#---------------------------------
		
		
		#--------Visuelle Elemente--------
		ball_model.mesh = ball_meshes[2]
		collision_ball_node.shape = collision_ball_shapes[0]
		collision_ball_node.scale = Vector3(0.42,0.42,0.42)
		#---------------------------------

func fall_cam(y: float):
	if fell == false:
		fell = true
		cam_y_position = y
		await get_tree().create_timer(2).timeout
		u_ianims.play("gameover")

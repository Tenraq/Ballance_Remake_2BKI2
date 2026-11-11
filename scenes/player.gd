extends RigidBody3D
#-----------------------------------------Variablen-----------------------------------------

@onready var camera: Camera3D = $"camera holder/Camera"
@onready var camera_holder: Node3D = $"camera holder"

@onready var deathscreen: ColorRect = $UI/deathscreen
@onready var u_ianims: AnimationPlayer = $UI/UIanims

#collisionen
@onready var collision_ball_node: CollisionShape3D = $collision_ball
@onready var collision_ball_shapes = [
	preload("res://MDLS/ball_meshe/paper_collison.tres"), 
	preload("res://MDLS/ball_meshe/normal_collison.tres")
	] 
@onready var lookat_node_3d: Node3D = $lookatNode3D

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
var over_fan = 0
var ball_alive = true
var can_control_player = true
var lives = 1
@onready var lives_UI: Label = $UI/lives

#audio_nodes
@onready var hitsound: AudioStreamPlayer3D = $hitsound
@onready var rollsound_wood: AudioStreamPlayer3D = $rollsound_wood
@onready var rollsound_stone: AudioStreamPlayer3D = $rollsound_stone
@onready var rollsound_metal: AudioStreamPlayer3D = $rollsound_metal

@export var wood_parts:PackedScene
@export var stone_parts:PackedScene
@export var paper_parts:PackedScene
@onready var hit: GPUParticles3D = $hit




#-----------------------------------------ready-----------------------------------------

func _ready() -> void:
	current_ball = BallTypes.types.wood
	print("git?")
	respawn = global_position
	
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
			camera.position = camera.position.lerp(Vector3(0,6.6,1.2),5 * delta)
		else:
			camera.position = camera.position.lerp(Vector3(0,3,1.2),5 * delta)
	else:
		fall_cam(camera.global_position.y)
		camera.global_position.y = cam_y_position
	
	apply_central_force(Vector3(0,4.5 * over_fan,0))
	
	
	camera_holder.global_position = camera_holder.global_position.lerp(global_position, camera_follow_speed * delta)
	lookat_node_3d.global_position = lookat_node_3d.global_position.lerp(global_position, (camera_follow_speed * 1.7)* delta)
	camera.look_at(lookat_node_3d.position)
	
	if Input.is_action_just_pressed("G") and hit.emitting == false:
		hit.emitting = true
		cycle = cycle + 1
		if cycle > 2:
			cycle = 0
		if cycle == 0:
			if current_ball == BallTypes.types.wood:
				var wood_parts_inst:Node3D = wood_parts.instantiate()
				get_parent().add_child(wood_parts_inst)
				wood_parts_inst.position = self.position
				wood_parts_inst.rotation = self.rotation
			elif current_ball == BallTypes.types.stone:
				var stone_parts_inst:Node3D = stone_parts.instantiate()
				get_parent().add_child(stone_parts_inst)
				stone_parts_inst.position = self.position
				stone_parts_inst.rotation = self.rotation
			else:
				var paper_parts_inst:Node3D = paper_parts.instantiate()
				get_parent().add_child(paper_parts_inst)
				paper_parts_inst.position = self.position
				paper_parts_inst.rotation = self.rotation
			ballSwitch(BallTypes.types.wood)
		if cycle == 1:
			if current_ball == BallTypes.types.wood:
				var wood_parts_inst:Node3D = wood_parts.instantiate()
				get_parent().add_child(wood_parts_inst)
				wood_parts_inst.position = self.position
				wood_parts_inst.rotation = self.rotation
			elif current_ball == BallTypes.types.stone:
				var stone_parts_inst:Node3D = stone_parts.instantiate()
				get_parent().add_child(stone_parts_inst)
				stone_parts_inst.position = self.position
				stone_parts_inst.rotation = self.rotation
			else:
				var paper_parts_inst:Node3D = paper_parts.instantiate()
				get_parent().add_child(paper_parts_inst)
				paper_parts_inst.position = self.position
				paper_parts_inst.rotation = self.rotation
			ballSwitch(BallTypes.types.stone)
		if cycle == 2:
			if current_ball == BallTypes.types.wood:
				var wood_parts_inst:Node3D = wood_parts.instantiate()
				get_parent().add_child(wood_parts_inst)
				wood_parts_inst.position = self.position
				wood_parts_inst.rotation = self.rotation
			elif current_ball == BallTypes.types.stone:
				var stone_parts_inst:Node3D = stone_parts.instantiate()
				get_parent().add_child(stone_parts_inst)
				stone_parts_inst.position = self.position
				stone_parts_inst.rotation = self.rotation
			else:
				var paper_parts_inst:Node3D = paper_parts.instantiate()
				get_parent().add_child(paper_parts_inst)
				paper_parts_inst.position = self.position
				paper_parts_inst.rotation = self.rotation
			ballSwitch(BallTypes.types.paper)
	
	
	
	if ball_alive == true:
		if global_position.y < -10:
			ball_alive = false
			if lives > 0:
				axis_lock_linear_x = true
				axis_lock_linear_z = true
				u_ianims.play("fail")
				await u_ianims.animation_finished
				
				global_position = respawn
				await  get_tree().create_timer(1).timeout
				
				ball_alive = true
				u_ianims.play_backwards("fail")
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
		current_ball = typeTo
		
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
		current_ball = typeTo
		
		speed = 22
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
		current_ball = typeTo
		
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


func _on_body_entered(_body: Node) -> void:
	pass


func _on_body_exited(_body: Node) -> void:
	pass # Replace with function body.


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print(get_colliding_bodies()) # Replace with function body.

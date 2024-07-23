extends RigidBody3D

const LERP_SPEED: float = 7.5

@export var float_force: float = 1.0
@export var water_drag: float = 0.05
@export var water_angular_drag: float = 0.5

@export var camera_anchor: Marker3D
@export var camera_3d: Camera3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var label = $CanvasLayer/Label

var submerged: bool = false

var rotation_force: float = 0
var forward_force: float = 0

var speed: float = 25.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		camera_anchor.rotate_y(deg_to_rad(-event.relative.x * 0.05))

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		camera_3d.fov = 80
		speed = 45.0
	else:
		camera_3d.fov = 75
		speed = 35.0

func _physics_process(delta):
	handle_input(delta)
	
	camera_3d.global_rotation.z = 0.0
	
	submerged = false
	var depth = WaterManager.get_wave_height(global_position) - global_position.y
	if depth > 0:
		submerged = true
		apply_central_force(Vector3.UP * float_force * gravity * depth)
	
	apply_force(Vector3(forward_force, 0, 0).rotated(Vector3.UP, global_rotation.y) * speed)
	rotate(Vector3.UP, rotation_force / 90)
	
	label.text = str(linear_velocity.length())
	WaterManager.wave_offset = global_position

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1.0 - water_drag
		state.angular_velocity *= 1.0 - water_angular_drag

func handle_input(delta: float):
	var input_x = Input.get_axis("forward", "back")
	if input_x:
		forward_force = lerp(forward_force, input_x, LERP_SPEED / 2.0 * delta)
	else:
		forward_force = lerp(forward_force, 0.0, LERP_SPEED / 4.0 * delta)
	
	var input_z = Input.get_axis("right", "left")
	if input_z:
		rotation_force = lerp(rotation_force, input_z, (LERP_SPEED / 4.0) * delta)
	else:
		rotation_force = lerp(rotation_force, 0.0, (LERP_SPEED / 3.5) * delta)

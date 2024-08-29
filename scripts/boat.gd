class_name Boat
extends RigidBody3D

var mouse_movement: Vector2 = Vector2()

var linear_force: float = 25
var angular_force: float = 5

@onready var h = $CameraAnchor/H
@onready var v = $CameraAnchor/H/V

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inertia = Vector3(0, 1, 0)

func _input(event):
	if event is InputEventMouseMotion:
		h.rotation_degrees.y += -event.relative.x * 0.0625
		v.rotation_degrees.z += event.relative.y * 0.0625
		v.rotation_degrees.z = clampf(v.rotation_degrees.z, -15.0, 45.0)

func _physics_process(_delta):
	var linear_input = Input.get_axis("forward", "back")
	if linear_input:
		if linear_input > 0:
			linear_input = 0.35
		apply_central_force(Vector3(linear_force * linear_input, 0, 0).rotated(Vector3.UP, global_rotation.y))
	
	var angular_input = Input.get_axis("right", "left")
	if angular_input:
		apply_torque(Vector3(0, angular_force * angular_input, 0))

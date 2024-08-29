class_name Floater
extends Node3D

@export var rigid_body: RigidBody3D

@onready var buoy = $Buoy

func _physics_process(_delta):
	buoy.position.y = WaveManager.get_wave_height(global_position) - global_position.y

func get_buoy_position() -> Vector3:
	return Vector3(position.x, buoy.position.y, position.z)

class_name Floater
extends Node3D

@onready var buoy = $Buoy

func _physics_process(_delta):
	var wave_height = WaterManager.get_wave_height(global_position)
	print(wave_height)
	buoy.position.y = wave_height - global_position.y

func get_buoy_position() -> Vector3:
	return Vector3(position.x, buoy.position.y, position.z)

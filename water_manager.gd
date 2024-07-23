extends Node

@export var wave_noise_1: NoiseTexture2D # small waves
@export var wave_noise_2: NoiseTexture2D # bigger waves
@export var water_mesh: Node3D

var wave_offset: Vector3:
	set(value):
		pass
		#wave_offset = Vector3(value.x, value.z, 0)
		#water_mesh.global_position = Vector3(value.x, 0, value.z)

var time: float = 0
var wave_direction: Vector3 = Vector3(1, 0, 1)
var wave_speed: float = 5.0


func _process(delta: float):
	time += delta
	var offset_1 = (wave_offset + (wave_direction * time) * wave_speed)
	var offset_2 = (wave_offset + (wave_direction * time) * wave_speed * 0.5)
	
	if wave_noise_1.noise is FastNoiseLite:
		wave_noise_1.noise.offset = offset_1
	
	if wave_noise_2.noise is FastNoiseLite:
		wave_noise_2.noise.offset = offset_2

func get_wave_height(world_pos: Vector3) -> float:
	var pos = world_pos - water_mesh.global_position
	
	var noise_pos = Vector2(pos.x, pos.z) + (wave_noise_1.get_size() / 2)
	
	return (wave_noise_1.noise.get_noise_2d(noise_pos.x, noise_pos.y) + (wave_noise_2.noise.get_noise_2d(noise_pos.x, noise_pos.y) * 0))
	#return sin(world_pos.x * 0.125 + world_pos.z * 0.0625 + time * wave_speed) * wave_scale

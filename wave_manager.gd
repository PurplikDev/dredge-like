extends Node

@export var noise_1_direction: Vector3
@export var noise_2_direction: Vector3
@export var wave_speed: float

@export var water_mesh: MeshInstance3D

@export_group("Noise")
@export var wave_noise_1: NoiseTexture2D
@export var wave_noise_2: NoiseTexture2D
@export var ripple_noise: NoiseTexture2D

var time: float = 0

var material: Material
var speed: float
var steepness: float
var amplitude: float
var wavelength: float
var direction: Vector2

func _ready():
	material = water_mesh.get_active_material(0)
	speed = material.get_shader_parameter("speed")
	steepness = material.get_shader_parameter("steepness")
	amplitude = material.get_shader_parameter("amplitude")
	wavelength = material.get_shader_parameter("wavelength")
	direction = material.get_shader_parameter("direction")

func _physics_process(delta):
	time += delta
	material.set_shader_parameter("time", time)
	
	wave_noise_1.noise.offset = (noise_1_direction * wave_speed * 0.9) * time
	wave_noise_2.noise.offset = (noise_2_direction * wave_speed * 1.1) * time
	ripple_noise.noise.offset = noise_1_direction * time

func get_wave_height(global_pos: Vector3):
	var noise_pos = Vector2(global_pos.x, global_pos.z) + (wave_noise_2.get_size() / 2)
	# (((wave_noise_2.noise.get_noise_2d(noise_pos.x, noise_pos.y))) + gerstner(global_pos, Vector2(1, 0.5), time, 1, 0.25, 0.125, 0.35)) * 0.75 + 2.5
	return (gerstner(global_pos) + (wave_noise_2.noise.get_noise_2d(noise_pos.x, noise_pos.y) * 4.5)) * 0.25 + 0.125

func gerstner(pos: Vector3) -> float:
	var displaced_y: float = pos.y + amplitude * sin(wavelength * direction.dot(Vector2(pos.x, pos.z)) + speed * time);
	return displaced_y

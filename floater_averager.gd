class_name FloaterAverager
extends Node

@export var floater_a: Floater # front right
@export var floater_b: Floater # front left
@export var floater_c: Floater # back right
@export var floater_d: Floater # back left

@export var object_to_rotate: Node3D


func _physics_process(_delta):
	
	var average_ab = (floater_a.get_buoy_position() + floater_b.get_buoy_position()) / 2
	var average_cd = (floater_c.get_buoy_position() + floater_d.get_buoy_position()) / 2
	
	var average_ac = (floater_a.get_buoy_position() + floater_c.get_buoy_position()) / 2
	var average_bd = (floater_b.get_buoy_position() + floater_d.get_buoy_position()) / 2
	
	var average_pos = (average_ab + average_cd + average_ac + average_bd) / 4
	object_to_rotate.position = average_pos
	
	var helper_ab = Node3D.new()
	helper_ab.look_at_from_position(average_pos, average_ab)
	
	var helper_ac = Node3D.new()
	helper_ac.look_at_from_position(average_pos, average_ac)
	
	object_to_rotate.rotation = Vector3(helper_ac.rotation.x, 0.0, -helper_ab.rotation.x)

@tool
class_name GerstnerWaveVertexNode
extends VisualShaderNodeCustom

func _get_category():
	return "Waves"

func _get_name():
	return "GerstnerWave"

func _get_code(input_vars, output_vars, _mode, _type):
	return "
	vec3 _vertex = %s;
	vec2 _direction = %s;
	float _time = %s;
	float _speed = %s;
	float _steepness = %s;
	float _amplitude = %s;
	float _wavelength = %s;
	
	float displaced_x = _vertex.x + (_steepness/_wavelength) * _direction.x * cos(_wavelength * dot(_direction, _vertex.xz) + _speed * _time);
	float displaced_z = _vertex.z + (_steepness/_wavelength) * _direction.y * cos(_wavelength * dot(_direction, _vertex.xz) + _speed * _time);
	float displaced_y = _vertex.y + _amplitude * sin(_wavelength * dot(_direction, _vertex.xz) + _speed * _time);
	%s = vec3(displaced_x, displaced_y, displaced_z);
	" % [input_vars[0], input_vars[1], input_vars[2], input_vars[3], input_vars[4], input_vars[5], input_vars[6], output_vars[0]]

func _get_input_port_count():
	return 7

func _get_input_port_name(port):
	match port:
		0: return "vertex"
		1: return "direction"
		2: return "time"
		3: return "speed"
		4: return "steepness"
		5: return "amplitude"
		6: return "wavelength"

func _get_input_port_type(port):
	match port:
		0:
			return PORT_TYPE_VECTOR_3D
		1:
			return PORT_TYPE_VECTOR_2D

func _get_output_port_count():
	return 1

func _get_output_port_name(_port):
	return "result"

func _get_output_port_type(_port):
	return PORT_TYPE_VECTOR_3D

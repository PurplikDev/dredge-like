@tool
class_name GerstnerWaveNormalNode
extends VisualShaderNodeCustom

func _get_category():
	return "Waves"

func _get_name():
	return "GerstnerWaveNormal"

func _get_code(input_vars, output_vars, _mode, _type):
	return "
	vec3 _vertex = %s;
	vec2 _direction = %s;
	float _time = %s;
	float _speed = %s;
	float _steepness = %s;
	float _amplitude = %s;
	float _wavelength = %s;
	
	float cosfactor = cos(_wavelength * dot(_direction, _vertex.xz + _speed * _time));
	float sinfactor = sin(_wavelength * dot(_direction, _vertex.xz + _speed * _time));
	float x_normal = -_direction.x * _wavelength * _amplitude * cosfactor;
	float z_normal = -_direction.y * _wavelength * _amplitude * cosfactor;
	float y_normal = 1.0 - (_steepness/_wavelength) * _wavelength * _amplitude * sinfactor;
	%s = vec3(x_normal, y_normal, z_normal);
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

shader_type spatial;

uniform sampler2D foam_noise;

uniform vec4 water_color: source_color;
uniform vec3 foam_color: source_color;

uniform float wave_time = 0.0;
uniform float wave_scale = 0.5;
uniform float wave_speed = 0.5;

uniform vec3 wave_offset = vec3(0,0,0);

void vertex() {
	vec2 global_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz; 
	float wave = sin(global_position.x * 0.125 + global_position.y * 0.0625 + wave_time * wave_speed) * wave_scale;
	VERTEX.y += wave;
}

void fragment() {
	vec3 foam = texture(foam_noise, UV + vec2(wave_time * 0.0125)).rgb;
	ALBEDO = water_color.rgb + pow(foam, vec3(10));
	METALLIC = 0.0;
	ROUGHNESS = 0.01;
	ALPHA = water_color.a;
}

// stolen code
/*
uniform vec3 wave_a = vec3(1.0, 1.0, 10.0);
uniform vec2 wave_a_dir = vec2(1.0, 0.0);

uniform vec3 wave_b = vec3(1.0, 0.25, 20.0);
uniform vec2 wave_b_dir = vec2(1.0, 1.0);

varying float wave_height;

vec3 gerstnerWave(vec3 wave, vec2 wave_dir, vec3 p, inout vec3 tangent, inout vec3 binormal, float t) {
	float amplitude = wave.x;
	float steepness = wave.y;
	float wavelength = wave.z;
	
	float k = 2.0 * PI / wavelength;
	float c = sqrt(9.8 / k); // phase speed
	vec2 d = normalize(wave_dir);
	float f = k * (dot(d, p.xz) - (c * t));
	float a = steepness / k;
	
	tangent += normalize(vec3(
		1.0 - d.x * d.x * steepness * sin(f),
		d.x * steepness * cos(f),
		-d.x * d.y * (steepness * sin(f))
	));
	binormal += normalize(vec3(
		-d.x * d.y * (steepness * sin(f)),
		d.y * steepness * cos(f),
		1.0 - (d.y * d.y * steepness * sin(f))
	));
	
	return vec3(
		d.x * (a * cos(f)),
		amplitude * a * sin(f),
		d.y * (a * cos(f))
	);
}

void vertex() {
	vec3 original_p = (MODEL_MATRIX * vec4(VERTEX.xyz, 1.0)).xyz;
	vec3 p = VERTEX.xyz;
	vec3 tangent = vec3(1.0, 0.0, 0.0);
	vec3 binormal = vec3(0.0, 0.0, 1.0);
	
	p += gerstnerWave(wave_a, wave_a_dir, original_p, tangent, binormal, wave_time);
	p += gerstnerWave(wave_b, wave_b_dir, original_p, tangent, binormal, wave_time);
	
	vec3 normal = normalize(cross(binormal, tangent));
	
	VERTEX = p;
	TANGENT = tangent;
	BINORMAL = binormal;
	NORMAL = normal;
	
	wave_height = p.y;
}*/
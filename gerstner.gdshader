shader_type spatial;

uniform vec2 testdirection;
uniform float speeed;
uniform float steeepness : hint_range(0.0, 1.0, 0.05) = 1.0;
uniform float aamplitude = 1.0;
uniform float waavelength = 1.0;

uniform vec4 water_color : source_color;
uniform vec4 deep_water_color : source_color;

uniform sampler2D depth_tex_frg_14;
uniform sampler2D depth_tex_frg_2;
uniform sampler2D depth_tex_frg_73;
uniform sampler2D depth_tex_frg_9;

uniform sampler2D wave_noise_1;
uniform sampler2D wave_noise_2;
uniform sampler2D ripple_noise;

// direction.y represents z axis (since it is 2D vec)
vec3 gerstner(vec3 vertex, vec2 direction, float time, float speed, float steepness, float amplitude, float wavelength){
	float displaced_x = vertex.x + (steepness/wavelength) * direction.x * cos(wavelength * dot(direction, vertex.xz) + speed * time);
	float displaced_z = vertex.z + (steepness/wavelength) * direction.y * cos(wavelength * dot(direction, vertex.xz) + speed * time);
	float displaced_y = vertex.y + amplitude * sin(wavelength * dot(direction, vertex.xz) + speed * time);
	return vec3(displaced_x, displaced_y, displaced_z);
}

vec3 gerstner_normal(vec3 vertex, vec2 direction, float time, float speed, float steepness, float amplitude, float wavelength) {
    float cosfactor = cos(wavelength * dot(direction, vertex.xz + speed * time));
	float sinfactor = sin(wavelength * dot(direction, vertex.xz + speed * time));
	float x_normal = -direction.x * wavelength * amplitude * cosfactor;
	float z_normal = -direction.y * wavelength * amplitude * cosfactor;
	float y_normal = 1.0 - (steepness/wavelength) * wavelength * amplitude * sinfactor;
	return vec3(x_normal, y_normal, z_normal);
}

void vertex(){
	VERTEX = gerstner(VERTEX, normalize(testdirection), TIME, speeed, steeepness, aamplitude, waavelength);
	NORMAL = gerstner_normal(VERTEX, normalize(testdirection), TIME, speeed, steeepness, aamplitude, waavelength);
}

void fragment() {
// ColorParameter:19
	vec4 n_out19p0 = deep_water_color;


// ColorParameter:4
	vec4 n_out4p0 = water_color;


	float n_out14p0;
// ProximityFade:14
	float n_in14p0 = 8.00000;
	{
		float __depth_tex = texture(depth_tex_frg_14, SCREEN_UV).r;
		vec4 __depth_world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, __depth_tex, 1.0);
		__depth_world_pos.xyz /= __depth_world_pos.w;
		n_out14p0 = clamp(1.0 - smoothstep(__depth_world_pos.z + n_in14p0, __depth_world_pos.z, VERTEX.z), 0.0, 1.0);
	}


// FloatFunc:17
	float n_out17p0 = 1.0 - n_out14p0;


// Mix:18
	vec4 n_out18p0 = mix(n_out19p0, n_out4p0, vec4(n_out17p0));


// ParameterRef:81
	vec3 n_out81p0 = water_color.rgb;
	float n_out81p1 = water_color.a;


	vec4 n_out77p0;
// Texture2D:77
	n_out77p0 = texture(wave_noise_2, UV);


// FloatConstant:80
	float n_out80p0 = 0.250000;


// VectorOp:79
	vec3 n_out79p0 = vec3(n_out77p0.xyz) * vec3(n_out80p0);


// Mix:76
	vec3 n_out76p0 = mix(vec3(n_out18p0.xyz), n_out81p0, n_out79p0);


	vec4 n_out29p0;
// Texture2D:29
	n_out29p0 = texture(ripple_noise, UV);


// FloatConstant:61
	float n_out61p0 = 0.800000;


// VectorOp:62
	vec3 n_out62p0 = vec3(n_out29p0.xyz) * vec3(n_out61p0);


// VectorFunc:63
	vec3 n_out63p0 = round(n_out62p0);


	vec4 n_out47p0;
// Texture2D:47
	n_out47p0 = texture(wave_noise_1, UV);


// FloatConstant:54
	float n_out54p0 = 5.000000;


// VectorOp:53
	vec3 n_out53p0 = pow(vec3(n_out47p0.xyz), vec3(n_out54p0));


// VectorOp:56
	vec3 n_out56p0 = n_out63p0 * n_out53p0;


// VectorOp:70
	vec3 n_in70p1 = vec3(0.00000, 0.00000, 0.00000);
	vec3 n_out70p0 = n_out56p0 + n_in70p1;


// VectorOp:46
	vec3 n_out46p0 = n_out76p0 + n_out70p0;


	vec4 n_out82p0;
// Texture2D:82
	n_out82p0 = texture(ripple_noise, UV);
	float n_out36p0 = 2.000000;
	vec3 n_out35p0 = vec3(n_out82p0.xyz) * vec3(n_out36p0);
	vec3 n_out32p0 = round(n_out35p0);
	float n_out2p0;
	float n_in2p0 = 5.00000;
	{
		float __depth_tex = texture(depth_tex_frg_2, SCREEN_UV).r;
		vec4 __depth_world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, __depth_tex, 1.0);
		__depth_world_pos.xyz /= __depth_world_pos.w;
		n_out2p0 = clamp(1.0 - smoothstep(__depth_world_pos.z + n_in2p0, __depth_world_pos.z, VERTEX.z), 0.0, 1.0);
	}
	float n_out3p0 = 1.0 - n_out2p0;
	float n_in8p1 = 0.25000;
	float n_out8p0 = n_out3p0 * n_in8p1;
	float n_out21p0 = TIME;
	float n_in27p1 = 0.50000;
	float n_out27p0 = fma(n_out21p0, n_in27p1, n_out3p0);
	float n_in26p1 = 1.50000;
	float n_out26p0 = n_out27p0 * n_in26p1;
	float n_out22p0 = sin(n_out26p0);
	float n_out24p0 = abs(n_out22p0);
	float n_out71p0 = 1.0 - n_out24p0;
	float n_out23p0 = n_out8p0 * n_out71p0;
	vec3 n_out30p0 = n_out32p0 * vec3(n_out23p0);
	float n_out73p0;
	float n_in73p0 = 1.50000;
	{
		float __depth_tex = texture(depth_tex_frg_73, SCREEN_UV).r;
		vec4 __depth_world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, __depth_tex, 1.0);
		__depth_world_pos.xyz /= __depth_world_pos.w;
		n_out73p0 = clamp(1.0 - smoothstep(__depth_world_pos.z + n_in73p0, __depth_world_pos.z, VERTEX.z), 0.0, 1.0);
	}
	float n_out72p0 = 1.0 - n_out73p0;
	float n_out9p0;
	float n_in9p0 = 0.25000;
	{
		float __depth_tex = texture(depth_tex_frg_9, SCREEN_UV).r;
		vec4 __depth_world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, __depth_tex, 1.0);
		__depth_world_pos.xyz /= __depth_world_pos.w;
		n_out9p0 = clamp(1.0 - smoothstep(__depth_world_pos.z + n_in9p0, __depth_world_pos.z, VERTEX.z), 0.0, 1.0);
	}
	float n_out10p0 = 1.0 - n_out9p0;
	float n_out11p0 = ceil(n_out10p0);
	float n_in75p1 = 0.25000;
	float n_out75p0 = fma(n_out72p0, n_in75p1, n_out11p0);
	float n_out12p0 = n_out30p0.x + n_out75p0;
	vec3 n_in28p2 = vec3(0.50000, 0.50000, 0.50000);
	vec3 n_out28p0 = mix(n_out46p0, vec3(n_out12p0), n_in28p2);
	float n_out55p0 = 1.0 - n_out53p0.x;
	ALBEDO = n_out28p0;
	ROUGHNESS = n_out55p0;
}
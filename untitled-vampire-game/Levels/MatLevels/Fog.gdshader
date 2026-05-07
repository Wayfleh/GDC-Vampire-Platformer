shader_type canvas_item;

// Uniforms for customization
uniform sampler2D noise_texture : repeat_enable;
uniform vec3 smoke_color : source_color = vec3(0.8);
uniform float distortion_speed : hint_range(0.0, 5.0) = 0.2;
uniform float density : hint_range(0.0, 1.0) = 1.0;
uniform float levels : hint_range(1.0, 30.0) = 5.0;

uniform float pixelation_amount: hint_range(32.0, 2048.0) = 0.0; // Higher = smaller pixels

uniform float fade_start : hint_range(0.0, 1.0) = 0.7;
uniform float fade_end : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	
    // Pre-calculate time-based offsets
    float time_offset_1 = TIME * distortion_speed * 0.1;
    float time_offset_2 = TIME * distortion_speed * 0.2;
    
    // Sample noise with distortion
    vec2 grid_uv = round(UV * pixelation_amount)/pixelation_amount;
    vec4 noise = texture(noise_texture, grid_uv + time_offset_1);
    
    vec3 posterized_color = floor(noise.rgb * levels) / levels; 
    // Create distorted UV and sample final noise
    vec2 distorted_uv = grid_uv - noise.rg * 0.1 - 0.05 + time_offset_2;
    
    
    float smoke_alpha = posterized_color.r * density;
    
	float alpha_mask = 1.0 - smoothstep(fade_start, fade_end, UV.y);
	
	
    // Output color
    COLOR =    vec4(smoke_color, smoke_alpha * alpha_mask);
}


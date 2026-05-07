shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.0;
uniform bool reverse = true;
uniform float edge_softness : hint_range(0.0, 1.0) = 0.1;
uniform float levels : hint_range(1.0, 30.0) = 5.0;
uniform float pixelation_amount: hint_range(32.0, 2048.0) = 32.0; // Higher = smaller pixels
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

void fragment() {
	// Generate diagonal sweep based on UV coordinates (0.0 to 1.0)
    // Adding X and Y creates a diagonal line
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 grid_uv = round(UV * screen_size / pixelation_amount) * pixelation_amount / screen_size ;
	float aspect = screen_size.x / screen_size.y;
    float diagonal;
	if (reverse)
		diagonal = (2.0 - grid_uv.x - grid_uv.y);
	else
		diagonal = grid_uv.x + grid_uv.y;
	
	
    
    // Animate the sweep using the progress uniform
    // We adjust the range to make it fade from top-left (0) to bottom-right (2)
    float mask = smoothstep(progress * 2.0 - edge_softness, progress * 2.0 + edge_softness, diagonal);
	
    float posterized_color = floor(mask * levels) / levels; 
    // Apply to alpha (if you want the shader to cut out objects)
    COLOR.a = 1.0 - posterized_color;
    
    // Optional: color the transition edge (e.g., black)
	
	COLOR.rgb = vec3(0.0);
	
}

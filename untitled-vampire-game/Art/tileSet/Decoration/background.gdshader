shader_type canvas_item;
uniform float darkness : hint_range(0.0, 1.0) = 0.5;

uniform vec4 blue_color : source_color = vec4(0.0, 0.0, 1.0, 1.0); 
uniform float intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Get the original texture color
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Mix the original color with blue
    vec3 blue_tinted = mix(tex_color.rgb, blue_color.rgb, intensity);
    // Multiply the RGB values by the darkness factor
    // We keep the original alpha (tex_color.a) so transparency isn't affected
    COLOR = vec4(blue_tinted * darkness, tex_color.a);
}
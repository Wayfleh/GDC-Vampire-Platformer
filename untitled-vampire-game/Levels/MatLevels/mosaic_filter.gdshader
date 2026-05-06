shader_type canvas_item;

uniform float mosaic_size = 10.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
    vec2 grid_uv = floor(SCREEN_UV * mosaic_size) / mosaic_size;
    vec4 text = texture(SCREEN_TEXTURE, grid_uv);
    COLOR = text;
}

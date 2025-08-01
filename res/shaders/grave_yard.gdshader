shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

void fragment() {
	vec3 color = texture(screen_texture, SCREEN_UV).rgb;

    color *= 0.8;

    color.b = min(1.0, color.b + 0.15);

    COLOR.rgb = color;
}

shader_type canvas_item;

void fragment() {
	vec4 color = COLOR;

    color.a -= 0.3;
    color.r -= 0.5;
    color.g += 0.4;
    color.b += 0.6;

    COLOR = color;
}

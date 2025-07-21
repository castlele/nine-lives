#version 330

in vec2 fragTexCoord;
out vec4 finalColor;

uniform sampler2D texture0;

void main() {
    vec4 original = texture(texture0, fragTexCoord);
    vec3 color = original.rgb;

    color *= 0.8;

    color.b = min(1.0, color.b + 0.15);

    finalColor = vec4(color, original.a);
}

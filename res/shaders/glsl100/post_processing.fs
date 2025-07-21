#version 100

precision mediump float;

varying vec2 fragTexCoord;
uniform sampler2D texture0;

void main() {
    vec4 original = texture2D(texture0, fragTexCoord);
    vec3 color = original.rgb;

    color *= 0.8;
    color.b = min(1.0, color.b + 0.15);

    gl_FragColor = vec4(color, original.a);
}

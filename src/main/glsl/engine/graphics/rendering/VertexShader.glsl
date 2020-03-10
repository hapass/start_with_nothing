attribute vec2 quad_position;
attribute vec3 quad_color;

uniform mat4 projection;
uniform vec3 glow_position;
varying vec4 color;

void main() {
    gl_Position = projection * vec4(quad_position, 0, 1);
    vec4 shine_position = gl_Position - projection * vec4(glow_position.xy, 0, 1);
    float shininess = max(1.0 - dot(shine_position.xy, shine_position.xy) * glow_position.z, 0.0);
    if (glow_position.z > 14.9)
    {
        shininess = 0.0;
    }
    color = vec4(quad_color, 1) * shininess;
}
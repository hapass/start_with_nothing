attribute vec2 quad_position;
attribute vec3 quad_color;

uniform mat4 projection;
varying vec4 color;

void main() {
    gl_Position = projection * vec4(quad_position, 0, 1);
    color = vec4(quad_color, 1);
}
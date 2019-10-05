attribute vec2 quad_position;

uniform mat4 projection;
uniform mat4 translation;
uniform mat4 scale;

void main() {
    gl_Position =  projection * translation * scale * vec4(quad_position, 0, 1);
}
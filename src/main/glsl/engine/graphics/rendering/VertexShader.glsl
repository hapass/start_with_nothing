attribute vec2 texture_quad_position;
attribute vec2 texture_position;

uniform mat4 projection;
uniform mat4 translation;
uniform mat4 scale;

varying vec2 texture_position_interpolated;

void main() {
    gl_Position =  projection * translation * scale * vec4(texture_quad_position, 0, 1);
    texture_position_interpolated = texture_position;
}
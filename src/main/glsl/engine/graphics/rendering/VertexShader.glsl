attribute vec2 texture_quad_position;
attribute vec2 texture_position;

uniform vec2 screen_size;
uniform mat4 translation;

varying vec2 texture_position_interpolated;

void main() {
    vec2 real_position = ((translation * texture_quad_position) / screen_size) * 2.0 - 1.0;
    gl_Position = vec4(real_position * vec2(1, -1), 0, 1);

    texture_position_interpolated = texture_position;
}
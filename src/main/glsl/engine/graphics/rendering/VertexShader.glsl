attribute vec2 texture_quad_position;
attribute vec2 texture_position;

uniform vec2 screen_size;
uniform vec2 translation;
uniform mat4 scale;

varying vec2 texture_position_interpolated;

void main() {
    vec2 real_position = ((scale * vec4(texture_quad_position, 0, 1) + vec4(translation, 0, 1)).xy / screen_size) * 2.0 - 1.0;
    gl_Position = vec4(real_position * vec2(1, -1), 0, 1);

    texture_position_interpolated = texture_position;
}
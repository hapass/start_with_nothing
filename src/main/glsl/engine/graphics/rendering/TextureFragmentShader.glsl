precision mediump float;

uniform sampler2D u_image;
varying vec2 texture_position_interpolated;

void main() {
    gl_FragColor = texture2D(u_image, texture_position_interpolated);
}
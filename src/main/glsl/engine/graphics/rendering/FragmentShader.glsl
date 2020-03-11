precision mediump float;

varying vec4 color;
uniform vec3 glow_position;
uniform mat4 projection;
uniform vec3 rand;

void main() {
    vec2 shine_position = gl_FragCoord.xy - vec2(glow_position.x, 600.0 - glow_position.y);
    vec2 frag_coord = vec2(shine_position.x / 800.0, shine_position.y / 600.0);
    float shininess = max(1.0 - sqrt(dot(frag_coord, frag_coord)) * glow_position.z, 0.0);
    if (glow_position.z > 14.9)
    {
        shininess = 0.0;
    }
    gl_FragColor = vec4(color.r + rand.r * shininess, color.g + rand.g * shininess, color.b + rand.b * shininess, 1) * shininess;
}
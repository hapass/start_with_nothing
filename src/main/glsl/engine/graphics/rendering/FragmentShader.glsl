precision mediump float;

varying vec4 color;
uniform vec3 glow_position;
uniform mat4 projection;
uniform vec2 screen_size;
uniform vec3 rand;

void main() {
    vec2 shine_position = gl_FragCoord.xy - vec2(glow_position.x, screen_size.y - glow_position.y);
    vec2 frag_coord = vec2(shine_position.x / screen_size.x, shine_position.y / screen_size.y);
    float radius = glow_position.z;
    float shininess = 0.0;
    if (radius > 0.0001)
    {
        shininess = max(1.0 - sqrt(dot(frag_coord, frag_coord)) / (radius * 2.0), 0.0);
    }

    float gamma = 2.2;
    gl_FragColor = vec4(pow(vec3(color.r + rand.r, color.g + rand.g, color.b + rand.b) * shininess, vec3(1.0/gamma)), 1);
}
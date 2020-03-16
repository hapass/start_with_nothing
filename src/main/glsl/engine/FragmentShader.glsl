precision mediump float;

varying vec4 color;
uniform vec3 light_configuration;
uniform mat4 screen_space_projection;

void main() {
    vec2 light_position = light_configuration.xy;
    float light_radius = light_configuration.z;

    vec2 light_fragment_difference = gl_FragCoord.xy - (screen_space_projection * vec4(light_position, 0, 1)).xy;

    float light_intensity = 0.0;
    if (light_radius > 0.0001)
    {
        light_intensity = max(1.0 - dot(light_fragment_difference, light_fragment_difference) / (light_radius * light_radius), 0.0);
    }

    float gamma = 2.2;
    gl_FragColor = vec4(pow(vec3(color.r, color.g, color.b) * light_intensity, vec3(1.0 / gamma)), 1);
}
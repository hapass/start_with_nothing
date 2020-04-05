precision mediump float;

varying vec4 color;
uniform vec3 light_configuration;
uniform mat4 screen_space_projection;

void main() {
    vec4 light_configuration_screen_space = screen_space_projection * vec4(light_configuration, 1);
    float light_radius = light_configuration_screen_space.z;

    float light_intensity = 0.0;
    if (light_radius > 0.0001)
    {
        vec2 light_fragment_difference = gl_FragCoord.xy - light_configuration_screen_space.xy;
        light_intensity = max(1.0 - dot(light_fragment_difference, light_fragment_difference) / (light_radius * light_radius), 0.0);
    }

    float gamma = 2.2;
    gl_FragColor = vec4(pow(vec3(color.r, color.g, color.b) * light_intensity, vec3(1.0 / gamma)), 1);
}
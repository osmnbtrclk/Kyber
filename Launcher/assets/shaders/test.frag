uniform float u_time;// Time for the flickering effect
uniform vec2 u_resolution;// Resolution of the rendering area


out vec4 fragColor;

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    float flicker = abs(sin(u_time));// Create a flickering effect

    // Hologram color, adjust RGB values for desired color
    vec4 color = vec4(0.0, 0.7, 1.0, 1.0);

    // Apply the flicker to the alpha channel for transparency
    color.a *= flicker;

    fragColor = color;
}

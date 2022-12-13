#version GLSL_VERSION
#define left  -1.0f
#define top  1.0f
#define right  1.0f
#define bottom  -1.0f
#define tex_left 0
#define tex_top 0
#define tex_right 1
#define tex_bottom 1
#define x_axis 0
#define y_axis 1
#define window i
#define image i + 2

uniform float tiled;
uniform vec4 sizes;  // [ window_width, window_height, image_width, image_height ]

out vec2 texcoord;

const vec2 pos_map[] = vec2[4](
    vec2(left, top),
    vec2(left, bottom),
    vec2(right, bottom),
    vec2(right, top)
);
const vec2 tex_map[] = vec2[4](
    vec2(tex_left, tex_top),
    vec2(tex_left, tex_bottom),
    vec2(tex_right, tex_bottom),
    vec2(tex_right, tex_top)
);

float scale_factor(float window_size, float image_size) {
    return window_size / image_size;
}

float tiling_factor(int i) {
    return tiled * scale_factor(sizes[window], sizes[image]) + (1 - tiled);
}

void main() {
    vec2 tex_coords = tex_map[gl_VertexID];
    texcoord = vec2(
        tex_coords[x_axis] * tiling_factor(x_axis),
        tex_coords[y_axis] * tiling_factor(y_axis)
    );
    gl_Position = vec4(pos_map[gl_VertexID], 0, 1);
}

shader_type canvas_item;

#define diagonal(X, Y) pow(X, 2) + pow(Y, 2)

uniform vec2 center = vec2(0.5, 0.5);
uniform float r = 0.4;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	// Place fragment code here.
	COLOR = texture(TEXTURE, UV);
	if(diagonal(abs(center.x - UV.x), abs(center.y - UV.y)) < pow(r, 2)) COLOR = color;
    else COLOR.a = 0.0;
}

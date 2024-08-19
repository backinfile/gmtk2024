shader_type canvas_item;

uniform vec4 colorA: source_color;
uniform vec4 colorB: source_color;

varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float dist = ((uv.y - uv.x) + 1.) * .5;
	vec4 color = mix(colorA, colorB, dist);
	COLOR = color * modulate;
}


shader_type canvas_item;

uniform float speed = 0.0055;

void vertex() {
	UV.x += TIME * speed;
}

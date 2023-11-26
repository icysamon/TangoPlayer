shader_type canvas_item;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float angle = 0.1;

void fragment() {
	// Place fragment code here.
	COLOR = texture(TEXTURE, UV);
	//COLOR = color;
	COLOR = vec4(sin(TIME)/2.0,0.8,1.0,0.8);
	
	
	
	// Angle

//	if(UV.x < angle){
//		if(UV.y < angle || UV.y > 1.0 - angle){
//			COLOR.a = 0.0;
//		}
//	}
//	if(UV.x > 1.0 - angle){
//		if(UV.y < angle || UV.y > 1.0 - angle){
//			COLOR.a = 0.0;
//		}
//	}

}

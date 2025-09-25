#pragma header

vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 uv = openfl_TextureCoordv.xy;
uniform float iTime;

uniform float Soft;
uniform float Threshold;

void main() {
	float f = Soft/2.0;
	float a = Threshold - f;
	float b = Threshold + f;
	
	vec4 tx = flixel_texture2D(bitmap, fragCoord.xy/openfl_TextureSize.xy);
	float l = (tx.x + tx.y + tx.z) / 3.0;
	
	float v = smoothstep(a, b, l);
	
	gl_FragColor = vec4(v);
}
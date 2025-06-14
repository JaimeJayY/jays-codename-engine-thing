#pragma header

uniform float stronk;
uniform float iTime;
uniform vec2 pixel;

const bool allowWiggle = true;


vec2 uvp(vec2 uv) {
	return clamp(uv, 0.0, 1.0);
}

float outCirc(float t) {
	return sqrt(-t * t + 2.0 * t);
}

float rand(vec2 co) {
	return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 getFixedColor(vec2 uv) {
    vec4 size = _camSize / openfl_TextureSize.xyxy;
    
    if (size.x > uv.x || uv.x > (size.x + size.z) || size.y > uv.y || uv.y > (size.y + size.w)) {
        return vec4(0.0);
    }

    return flixel_texture2D(bitmap, uv);
}


void main() {
    vec3 col;
    float amp;
    
    amp = stronk;

    for (int i = 0; i < 3; i++) {

        vec2 size = openfl_TextureSize.xy / pixel;
        vec2 uv = floor(openfl_TextureCoordv.xy * size) / size;
        
        if (allowWiggle) {
            uv += vec2(sin(float(i) * amp), cos(float(i) * amp)) * amp * 0.05;
        }

        // Fetch original texture color using the new getFixedColor function
        vec3 texOrig = getFixedColor(uvp(uv)).rgb;
        
        // Apply random offset to UV coordinates
        uv.x += (rand(vec2(uv.y + float(i), iTime)) * 2.0 - 1.0) * amp * 0.8 * (texOrig[i] + 0.2);
        uv.y += (rand(vec2(uv.x, iTime + float(i))) * 2.0 - 1.0) * amp * 0.1 * (texOrig[i] + 0.2);
        
        // Fetch new texture color after UV modification using the new getFixedColor function
        vec3 tex = getFixedColor(uvp(uv)).rgb;

        tex += abs(tex[i] - texOrig[i]);
        
        tex *= rand(uv) * amp + 1.0;

        col[i] = tex[i];
    }

    // Output the final color
    gl_FragColor = vec4(col, flixel_texture2D(bitmap, openfl_TextureCoordv).a);
}


#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
uniform float iTime;
#define mainImage main

void main() {
    vec2 uv = fragCoord.xy / openfl_TextureSize.xy; 

    // Code snippet by WizardMantis441 on twitter!
    uv.x -= 0.5; uv.y *= cos(uv.x / 0.7); uv.x += 0.5;

    gl_FragColor = flixel_texture2D(bitmap, uv);;
}
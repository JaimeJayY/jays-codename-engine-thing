#pragma header
uniform sampler2D screenBitmap;
uniform float zoom;
uniform float width;
uniform float height;
uniform float scale;

uniform float scrollx;
uniform float scrolly;


vec4 getScreenSample(vec2 uv){
    uv *= scale;
    uv *= zoom;

    uv.x *= (1280.0 / width);
    uv.y *= (720.0 / height);

    uv.x *= 2;
    uv.y *= 2;

    return flixel_texture2D(screenBitmap,uv);
}

void main(){
    gl_FragColor = getScreenSample(openfl_TextureCoordv);
}
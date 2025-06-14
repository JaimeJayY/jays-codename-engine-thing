// source: https://www.shadertoy.com/view/Nss3WX
    // leer you are my goat ~ luscious
    
    #pragma header
    
    #define PIXEL_FACTOR 920.
    #define COLOR_FACTOR 3.
    
    //wiki Ordered dithering table
    const mat4 ditherTable = mat4(
        0.0, 8.0, 2.0, 10.0,
        12.0, 4.0, 14.0, 6.0,
        3.0, 11.0, 1.0, 9.0,
        15.0, 7.0, 13.0, 5.0
    );
    
    void main() {
        // Reduce pixels
        vec2 size = PIXEL_FACTOR * openfl_TextureSize.xy/openfl_TextureSize.x;
        vec2 coor = floor( openfl_TextureCoordv * size);
        vec2 uv = coor / size;
    
           // Get source color
        vec4 col = flixel_texture2D(bitmap, uv);
    
        // Dither
        col.rgb += ditherTable[int(mod(coor.x, 4))][int(mod(coor.y, 4))] * 0.015; // last number is dithering strength
    
        // Reduce colors
        col.rgb = floor(col.rgb * COLOR_FACTOR) / COLOR_FACTOR;
    
        // Output to screen
        gl_FragColor = col;
    }
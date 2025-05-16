#pragma header
    
    uniform float iTime;
    uniform float someXvalue_;
    uniform float someYvalue_;
    vec2 curve(vec2 uv)
    {
        uv = (uv - 0.5) * 2.0;
        uv *= 1.18;
        uv.x *= 1.0 + pow((abs(uv.y) / someXvalue_), 2.0); //5 and 4 do goofy shit
        uv.y *= 1.0 + pow((abs(uv.x) / someYvalue_), 2.0);
        uv  = (uv / 2.0) + 0.5;
        uv =  uv *0.92 + 0.04;
        return uv;
    }
    
    void mainImage( out vec4 fragColor, in vec2 fragCoord )
    {
        //Curve
        vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
        uv = curve( uv );
        
        vec3 col;
    
        // Chromatic
        col.r = flixel_texture2D(bitmap,vec2(uv.x,uv.y)).x; //   uv.x+0.003,uv.y
        col.g = flixel_texture2D(bitmap,vec2(uv.x,uv.y)).y; //   uv.x+0.000,uv.y
        col.b = flixel_texture2D(bitmap,vec2(uv.x,uv.y)).z; //   uv.x-0.003,uv.y
        
        //crt thing
        col *= step(0.0, uv.x) * step(0.0, uv.y);
        col *= 1.0 - step(1.0, uv.x) * 1.0 - step(1.0, uv.y);
        
        
        //darkens
        //col *= 0.5 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);
        //col *= vec3(0.95,1.05,0.95);
    
        
        //crt flicker
        col *= 0.99+0.03*sin(110.0*iTime);
    
        fragColor = vec4(col,flixel_texture2D(bitmap, uv).a);
    }
    
    void main() {
        mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
    }
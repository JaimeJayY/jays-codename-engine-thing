#pragma header
        vec2 uv = openfl_TextureCoordv.xy;
        vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
        vec2 iResolution = openfl_TextureSize;
        uniform float iTime;
        #define iChannel0 bitmap
        #define texture flixel_texture2D
        #define fragColor gl_FragColor
        #define mainImage main

        uniform float indensity;
        
        float randomNoise(float x, float y)
        {
            return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
        }
        
        void mainImage()
        {
            // Normalized pixel coordinates (from 0 to 1)
            
            float splitAmount = indensity * randomNoise(iTime, 2.0);
            // rgb split
            vec4 ColorR = texture(iChannel0, vec2(uv.x + splitAmount, uv.y));
            vec4 ColorG = texture(iChannel0, uv);
            vec4 ColorB = texture(iChannel0, vec2(uv.x - splitAmount, uv.y));
            float theAlpha = flixel_texture2D(bitmap,uv).a;
            
            // Output to screen
            fragColor = vec4(ColorR.r, ColorG.g, ColorB.b, theAlpha);
        }
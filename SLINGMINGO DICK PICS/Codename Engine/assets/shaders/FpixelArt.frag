// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel
    // https://www.shadertoy.com/view/XsjSzR

    #pragma header

    vec2 uv = openfl_TextureCoordv.xy;
    #define round(a) floor(a + 0.5)
    #define iResolution vec3(openfl_TextureSize, 0.)
    uniform float iTime;
    #define iChannel0 bitmap
    uniform sampler2D iChannel1;
    uniform sampler2D iChannel2;
    uniform sampler2D iChannel3;
    #define texture flixel_texture2D

    

    // third argument fix
    vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
        vec4 color = texture2D(bitmap, coord, bias);
        if (!hasTransform)
        {
            return color;
        }
        if (color.a == 0.0)
        {
            return vec4(0.0, 0.0, 0.0, 0.0);
        }
        if (!hasColorTransform)
        {
            return color * openfl_Alphav;
        }
        color = vec4(color.rgb / color.a, color.a);
        mat4 colorMultiplier = mat4(0);
        colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
        colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
        colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
        colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
        color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
        if (color.a > 0.0)
        {
            return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
        }
        return vec4(0.0, 0.0, 0.0, 0.0);
    }

    // variables which is empty, they need just to avoid crashing shader
    uniform float iTimeDelta;
    uniform float iFrameRate;
    uniform int iFrame;
    #define iChannelTime float[4](iTime, 0., 0., 0.)
    #define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
    uniform vec4 iMouse;
    uniform vec4 iDate;

    // Emulated input resolution.
    #if 0
    // Fix resolution to set amount.
    #define res (vec2(320.0/1.0,160.0/1.0))
    #else
    // Optimize for resize.
    #define res (iResolution.xy/2.5) //////////////////// hi hello change the 2 if you want more or less pixel junk on screen
    #endif

    // Hardness of scanline.
    //  -8.0 = soft
    // -16.0 = medium
    float hardScan=-8.0;

    // Hardness of pixels in scanline.
    // -2.0 = soft
    // -4.0 = hard
    float hardPix=-3.0;

    // Display warp.
    // 0.0 = none
    // 1.0/8.0 = extreme
    vec2 warp=vec2(1.0/32.0,1.0/24.0); 

    // Amount of shadow mask.
    float maskDark=2.5; // from 0.5
    float maskLight=1.5;

    //------------------------------------------------------------------------

    // sRGB to Linear.
    // Assuing using sRGB typed textures this should not be needed.
    float ToLinear1(float c){return(c<=0.04045)?c/12.92:pow((c+0.055)/1.055,2.4);}
    vec3 ToLinear(vec3 c){return vec3(ToLinear1(c.r),ToLinear1(c.g),ToLinear1(c.b));}

    // Linear to sRGB.
    // Assuing using sRGB typed textures this should not be needed.
    float ToSrgb1(float c){return(c<0.0031308?c*12.92:1.055*pow(c,0.41666)-0.055);}
    vec3 ToSrgb(vec3 c){return vec3(ToSrgb1(c.r),ToSrgb1(c.g),ToSrgb1(c.b));}

    // Nearest emulated sample given floating point position and texel offset.
    // Also zeros off screen.
    vec3 Fetch(vec2 pos,vec2 off){
    pos=floor(pos*res+off)/res;
    if(max(abs(pos.x-0.5),abs(pos.y-0.5))>0.5)return vec3(0.0,0.0,0.0);
    return ToLinear(texture(iChannel0,pos.xy,-16.0).rgb);}

    // Distance in emulated pixels to nearest texel.
    vec2 Dist(vec2 pos){pos=pos*res;return -((pos-floor(pos))-vec2(0.5));}
        
    // 1D Gaussian.
    float Gaus(float pos,float scale){return exp2(scale*pos*pos);}

    // 3-tap Gaussian filter along horz line.
    vec3 Horz3(vec2 pos,float off){
    vec3 b=Fetch(pos,vec2(-1.0,off));
    vec3 c=Fetch(pos,vec2( 0.0,off));
    vec3 d=Fetch(pos,vec2( 1.0,off));
    float dst=Dist(pos).x;
    // Convert distance to weight.
    float scale=hardPix;
    float wb=Gaus(dst-1.0,scale);
    float wc=Gaus(dst+0.0,scale);
    float wd=Gaus(dst+1.0,scale);
    // Return filtered sample.
    return (b*wb+c*wc+d*wd)/(wb+wc+wd);}

    // 5-tap Gaussian filter along horz line.
    vec3 Horz5(vec2 pos,float off){
    vec3 a=Fetch(pos,vec2(-2.0,off));
    vec3 b=Fetch(pos,vec2(-1.0,off));
    vec3 c=Fetch(pos,vec2( 0.0,off));
    vec3 d=Fetch(pos,vec2( 1.0,off));
    vec3 e=Fetch(pos,vec2( 2.0,off));
    float dst=Dist(pos).x;
    // Convert distance to weight.
    float scale=hardPix;
    float wa=Gaus(dst-2.0,scale);
    float wb=Gaus(dst-1.0,scale);
    float wc=Gaus(dst+0.0,scale);
    float wd=Gaus(dst+1.0,scale);
    float we=Gaus(dst+2.0,scale);
    // Return filtered sample.
    return (a*wa+b*wb+c*wc+d*wd+e*we)/(wa+wb+wc+wd+we);}

    // Return scanline weight.
    float Scan(vec2 pos,float off){
    float dst=Dist(pos).y;
    return Gaus(dst+off,hardScan);}

    // Allow nearest three lines to effect pixel.
    vec3 Tri(vec2 pos){
    vec3 a=Horz3(pos,-1.0);
    vec3 b=Horz5(pos, 0.0);
    vec3 c=Horz3(pos, 1.0);
    float wa=Scan(pos,-1.0);
    float wb=Scan(pos, 0.0);
    float wc=Scan(pos, 1.0);
    return a*wa+b*wb+c*wc;}

    // Distortion of scanlines, and end of screen alpha.
    vec2 Warp(vec2 pos){
    pos=pos*2.0-1.0;    
    pos*=vec2(1.0+(pos.y*pos.y)*warp.x,1.0+(pos.x*pos.x)*warp.y);
    return pos*0.5+0.5;}

    // Shadow mask.
    vec3 Mask(vec2 pos){
    pos.x+=pos.y*3.0;
    vec3 mask=vec3(maskDark,maskDark,maskDark);
    pos.x=fract(pos.x/6.0);
    if(pos.x<0.333)mask.r=maskLight;
    else if(pos.x<0.666)mask.g=maskLight;
    else mask.b=maskLight;
    return mask;}    

    // Draw dividing bars.
    float Bar(float pos,float bar){pos-=bar;return pos*pos<4.0?0.0:1.0;}

    float theAlpha = texture(bitmap,uv).a; // just delcaring it here causes a crash

    // Entry.
    void mainImage( out vec4 fragColor, in vec2 fragCoord ){

        // Unmodified.
        if(fragCoord.x<iResolution.x*0.){
            fragColor.rgb=Fetch(fragCoord.xy/iResolution.xy+vec2(0.,0.0),vec2(0.0,0.0));}
        else{
            vec2 pos=Warp(fragCoord.xy/iResolution.xy+vec2(0.,0.0));

            if(fragCoord.x<iResolution.x*0.){
                hardScan=.0;
                maskDark=maskLight=1.0;
                pos=Warp(fragCoord.xy/iResolution.xy);
            }

            fragColor.rgb=Tri(pos)*Mask(fragCoord.xy);
        }

        fragColor.a=theAlpha;  
        fragColor.rgb*=Bar(fragCoord.x,iResolution.x*0.)*Bar(fragCoord.x,iResolution.x*0.);
        fragColor.rgb=ToSrgb(fragColor.rgb);
    }



    void main() {
        mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
    }
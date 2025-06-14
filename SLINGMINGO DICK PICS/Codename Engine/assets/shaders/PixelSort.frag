
// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
uniform float randomVal = 0.5;
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

precision lowp int;
precision mediump float;

//"Random" function borrowed from The Book of Shaders: Random
float random ( vec2 xy )
{
    return fract( sin( dot( xy.xy, vec2(12, 78) ) ) );
}

float luminance(vec4 color)
{
    return ( (color.r * 0.3) + (color.g * 0.6) + (color.b * 0.1) ) * color.a;
}

// Returns the y coordinate of the first pixel that is brighter than the threshold
float getFirstThresholdPixel(vec2 xy, float threshold)
{
	float luma = luminance( texture( iChannel0, xy / iResolution.xy ) );

	//Looking at every sequential pixel is very resource intensive,
	//thus, well increment the inspected pixel by dividing the image height in sections,
	//and add a little randomness across the x axis to hide the division of said sections
    float increment = iResolution.y / (30.0 + (random( xy.xx ) * 6.0)); 

    //Check if the luminance of the current pixel is brighter than the threshold,
    //if not, check the next pixel
	while( luma <= threshold )
	{
		xy.y -= increment;
        if( xy.y <= 0.0 ) return 0.0;
		luma = luminance( texture( iChannel0, xy / iResolution.xy ) );
	}
    
	return xy.y;
}

//Puts 10 pixels in an array
vec4[10] putItIn( vec2 startxy, float size, vec4 colorarray[10] )
{
    vec2 xy;
    int j;
    
    for( j = 9; j >= 0; --j )
    {
        //Divide the line of pixels into 10 sections,
        //then store the pixel found at the junction of each section
        xy = vec2(startxy.x, startxy.y + (size / 9.0) * float(j));
        
        colorarray[j] = texture( iChannel0, xy / iResolution.xy );
    }
    
    return colorarray;
}

//An attempt at Bubble sort for 10 pixels, sorting them from darkest to brightest, top to bottom
vec4[10] sortArray(vec4 colorarray[10])
{
    vec4 tempcolor;
    int j;
    int swapped = 1;
    
    while( swapped > 0 )
    {
        swapped = 0;
		for( j = 9; j > 0; --j )
    	{
        	if( luminance(colorarray[j]) > luminance(colorarray[j - 1]) )
        	{           
            	tempcolor = colorarray[j];
            	colorarray[j] = colorarray[j - 1];
            	colorarray[j - 1] = tempcolor;
            
            	++swapped;
        	}
    	}
    }
    
    return colorarray;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{ 
	float firsty = getFirstThresholdPixel( vec2(fragCoord.x, iResolution.y), 0.0 );
    float secondy = getFirstThresholdPixel( vec2(fragCoord.x, firsty - 1.0), randomVal);

    //Only work on the pixels that are between the two threshold pixels
    if( fragCoord.y < firsty && fragCoord.y > secondy )
    {
		float size = firsty - secondy;

		vec4 colorarray[10];
		colorarray = putItIn( vec2(fragCoord.x, secondy), size, colorarray );
		colorarray = sortArray( colorarray );
	
		float sectionSize = size / 9.0;
		float location = floor( (fragCoord.y - secondy) / sectionSize );
		float bottom = secondy + (sectionSize * location);
		float locationBetween = (fragCoord.y - bottom) / sectionSize;

        //A simple method for "fading" between the colors of our ten sampled pixels
		vec4 topColor = colorarray[int(location) + 1] * locationBetween;
		vec4 bottomColor = colorarray[int(location)] * (1.0 - locationBetween);
		
		fragColor = topColor + bottomColor;
    }
    else
    {
		fragColor = texture( iChannel0, (fragCoord.xy / iResolution.xy) );
    }
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
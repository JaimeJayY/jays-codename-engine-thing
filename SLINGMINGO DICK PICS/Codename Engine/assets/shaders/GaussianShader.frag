//shader modified by santi dont steal it lmao
	#pragma header
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
	vec2 iResolution = openfl_TextureSize;
	#define texture flixel_texture2D
	#define mainImage main

	uniform float size;

	// GAUSSIAN BLUR SETTINGS {{{
	float Directions=16.;// BLUR DIRECTIONS (Default 16.0 - More is better but slower)
	float Quality=4.;// BLUR QUALITY (Default 4.0 - More is better but slower)
	// GAUSSIAN BLUR SETTINGS }}}

	void mainImage()
	{
		float Pi=6.28318530718;// Pi*2

		vec2 Radius=size/iResolution.xy;

		// Normalized pixel coordinates (from 0 to 1)
		vec2 uv=fragCoord/iResolution.xy;
		// Pixel colour
		vec4 Color=texture(bitmap,uv);

		// Blur calculations
		for(float d=0.;d<Pi;d+=Pi/Directions)
		{
			for(float i=1./Quality;i<=1.;i+=1./Quality)
			{
				Color+=texture(bitmap,uv+vec2(cos(d),sin(d))*Radius*i);
			}
		}

		// Output to screen
		Color/=Quality*Directions-15.;
		gl_FragColor=Color;
	}
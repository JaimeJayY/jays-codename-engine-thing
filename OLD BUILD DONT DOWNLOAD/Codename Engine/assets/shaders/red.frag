// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// ShaderToy code

//intencidad del efecto 
uniform float threshold;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normaliza las coordenadas del fragmento
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Obtiene el color del texel en las coordenadas UV
    vec3 color = texture(iChannel0, uv).rgb;

    // Calcula la luminosidad del color (escala de grises)
    float luminance = dot(color, vec3(0.299, 0.587, 0.114));

    // Determina si el color debe ser rojo o negro basado en el umbral
    vec3 modifiedColor = (luminance > threshold) ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 0.0, 0.0);

    // Mezcla entre la textura original y el color modificado basado en el umbral
    vec3 resultColor = mix(color, modifiedColor, step(0.01, threshold)); // `step(0.01, threshold)` asegura que el efecto se aplica solo si el umbral es mayor a un valor pequeo

    // Establece el color final del fragmento
    fragColor = vec4(resultColor, flixel_texture2D(bitmap, uv).w);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
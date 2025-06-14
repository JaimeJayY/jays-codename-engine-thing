attribute vec4 openfl_Vertex;
attribute vec2 openfl_TextureCoord;
varying vec2 openfl_TextureCoordVar;

void main() {
    gl_Position = openfl_Vertex;
    openfl_TextureCoordVar = openfl_TextureCoord;
}

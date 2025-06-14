import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText.FlxTextBorderStyle;
import funkin.backend.utils.NdllUtil;
import hxvlc.flixel.FlxVideoSprite;
import openfl.display.BlendMode;
import sys.FileSystem;
import funkin.backend.utils.WindowUtils;
import openfl.system.Capabilities;
import funkin.backend.utils.DiscordUtil;


var glitch:CustomShader = new CustomShader('Glitch');


var crtshader:CustomShader = new CustomShader('CRTShader');




var shader:CustomShader;
function postCreate() {
    shader = new CustomShader("CRTShader");
    shader.someXvalue_ = 4.0;
    shader.someYvalue_ = 4.0;
    camGame.addShader(shader);
}
function update(elapsed:Float) {
    if (shader != null) shader.iTime = Conductor.songPosition;
}

var lowQ = new CustomShader('lowQuality');
lowQ.colorTransform = true;
FlxG.game.addShader(lowQ);

function destroy() FlxG.game.removeShader(lowQ);   
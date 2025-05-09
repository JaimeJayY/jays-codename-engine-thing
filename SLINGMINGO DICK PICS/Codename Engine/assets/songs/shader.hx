var shaderReduce:CustomShader = new CustomShader("lowquality_0_reduce");
var shaderSharpen:CustomShader = new CustomShader("lowquality_1_sharpen");
var shaderBlockEffect:CustomShader = new CustomShader("lowquality_2_blockEffect");
var shaderMain:CustomShader = new CustomShader("lowquality_3_main");
var shaderAmplification:CustomShader = new CustomShader("lowquality_4_amplification");
import openfl.display.StageQuality;

FlxG.game.stage.quality = StageQuality.BEST;


function update(elapsed:Float) {
    if (FlxG.keys.justPressed.F9) {
    FlxG.game.addShader(shaderReduce);
    FlxG.game.addShader(shaderSharpen);
    FlxG.game.addShader(shaderBlockEffect);
    FlxG.game.addShader(shaderMain);
    FlxG.game.addShader(shaderAmplification);
    }
    if (FlxG.keys.justPressed.F10) {
    FlxG.game.removeShader(shaderReduce);
    FlxG.game.removeShader(shaderSharpen);
    FlxG.game.removeShader(shaderBlockEffect);
    FlxG.game.removeShader(shaderMain);
    FlxG.game.removeShader(shaderAmplification);
    }
} 

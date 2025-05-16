var shaderCRTShader:CustomShader = new CustomShader("CRTShader");
import openfl.display.StageQuality;

FlxG.game.stage.quality = StageQuality.BEST;


function update(elapsed:Float) {
    
    FlxG.game.addShader(CRTShader);
    
    }
} 

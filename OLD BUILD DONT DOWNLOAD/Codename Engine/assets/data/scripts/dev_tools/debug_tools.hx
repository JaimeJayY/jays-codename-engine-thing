import funkin.editors.charter.Charter;
import funkin.game.PlayState;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxBasePoint;
import funkin.backend.system.framerate.SystemInfo;
var botplayTxts:Array<FlxText> = [];
static var curBotplay:Bool = false;
static var devControlBotplay:Bool = true;

var instructions:FlxText;

var systemInfoText:FlxText;
var camcords:FlxText;
var theSysBool:Bool = false;
//free cam movement
var camFreeMoving:Bool = false;
//camera dedicated for any debug info
var camOther = new FlxCamera();
public var botplayTxt:FlxText;
function create(){
    FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;
}
function postCreate() {
    botplayTxt = new FlxText(0, 0, null, 'BOTPLAY', 32);
    botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    botplayTxt.visible = false;
    botplayTxt.borderSize = 1.25;
    botplayTxt.camera = camHUD;
    add(botplayTxt);

    instructions = new FlxText(20, 20, 1280,  "Buttons to Press:\n\n  4: Enable Botplay\n  5: Charting Menu\n  I: Debug Info\n  Arrow Keys: Move The Camera In CamGame Around\n  |: Reset Camera \n  (Will be adding more as time goes on)", 32);
    instructions.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    instructions.borderSize = 1.25;
    instructions.camera = camOther;
    add(instructions);
    new FlxTimer().start(5, () -> FlxTween.tween(instructions, {alpha: 0}, 3));
    //trace(SystemInfo.__formattedSysText);

    systemInfoText = new FlxText(0, 0, 1280, '' + SystemInfo.__formattedSysText, 32);
    systemInfoText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    systemInfoText.borderSize = 1.25;
    systemInfoText.camera = camOther;
    systemInfoText.alpha = 0;
    add(systemInfoText);

    camcords = new FlxText(0, systemInfoText.y + 60, 1280, 'camFollow.X: ' + camFollow.x + "\ncamFollow.y: " + camFollow.y, 32);
    camcords.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    camcords.borderSize = 1.25;
    camcords.camera = camOther;
    camcords.alpha = 0;
    add(camcords);
}

function onCameraMove(event){
    //trace(event.position);
    if(camFreeMoving) event.cancel();
}
function onNoteHit(event){
    if(player.cpu && event.character.curCharacter == boyfriend.curCharacter){
        health += 0.02;
    }
}
function update(elapsed:Float) {

    if (startingSong || !canPause || paused || health <= 0) return;
    camcords.text = 'camFollow.X: ' + camFollow.x + "\ncamFollow.y: " + camFollow.y;
    if (FlxG.keys.justPressed.FIVE) FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, true));
    if (FlxG.keys.justPressed.LEFT){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x - 10, camFollow.y);
    } 
    if (FlxG.keys.justPressed.DOWN){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x, camFollow.y + 10);
    } 
    if (FlxG.keys.justPressed.UP){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x, camFollow.y - 10);
    } 
    if (FlxG.keys.justPressed.RIGHT){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x + 10, camFollow.y);
    } 
    if (FlxG.keys.justPressed.BACKSLASH){
        camZooming = true;
        camFreeMoving = false;
    }
    updateBotplay(elapsed);
    
    if(FlxG.keys.justPressed.I) {
        if (systemInfoText.alpha = 0) {
            popupInfo(true);
        }
        else {
            popupInfo(false);
        }
    }

}

function popupInfo(theBool:Bool){
    if(theSysBool == false){
        FlxTween.tween(systemInfoText, {alpha: 1}, 0.7);
        FlxTween.tween(camcords, {alpha: 1}, 0.7);

        theSysBool = true;
    }
    else{
        FlxTween.tween(systemInfoText, {alpha: 0}, 0.7);
        FlxTween.tween(camcords, {alpha: 0}, 0.7);

        theSysBool = false;

    }
}

var leAlpha:Float = 0;
function setBotplayTxtsAlpha(input:Float) {
	botplayTxt.alpha = input;
}

public var botplaySine:Float = 0;
function updateBotplay(elapsed:Float) {
	if (FlxG.keys.justPressed.FOUR) curBotplay = !curBotplay;
    for(strumLine in strumLines){
    if (!strumLine.opponentSide) {
        strumLine.cpu = FlxG.keys.pressed.FIVE || curBotplay;
        botplayTxt.visible = curBotplay;
    }
    }

		// stole from cne source lmao
		var pos = new FlxBasePoint();
		var scale = new FlxBasePoint();
		var r = 0;
		if (r > 0) {
			pos.x /= r;
			pos.y /= r;
			scale.x /= r;
			scale.y /= r;
			botplayTxt.scale.set(scale.x * 1.43, scale.y * 1.43);

		}
		pos.put();
		scale.put();
	if (curBotplay) {
		botplaySine += 180 * elapsed;
		leAlpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		setBotplayTxtsAlpha(leAlpha);
	}
    botplayTxt.screenCenter();
    botplayTxt.y = healthBar.y - 90;
    if (!curBotplay){
        leAlpha = 0;
        botplayTxt.alpha = 0;
    }
}
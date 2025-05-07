// libraries
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import openfl.system.Capabilities;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.CodenameBuildField;
import funkin.backend.system.Main;
// DEFAULT WINDOW POSITIONS
static var winX:Int = FlxG.stage.application.window.display.bounds.width / 6;
static var winY:Int = FlxG.stage.application.window.display.bounds.height / 6;

// MONITOR RESOLUTION
static var fsX:Int = Capabilities.screenResolutionX;
static var fsY:Int = Capabilities.screenResolutionY;

// WINDOW SIZE CHANGE VAR
static var resizex:Int = Capabilities.screenResolutionX / 1.5;
static var resizey:Int = Capabilities.screenResolutionY / 1.5;

static var windowTitle:String = "Funkdela Reloaded";
// functions
function postStateSwitch(){ //post is more consistent than pre
	//set commit id to mod name
	Framerate.codenameBuildField.text = 'Codename Engine '+ Main.releaseCycle +' \nFunkdela Reloaded';
	// title
	window.title = windowTitle;
	// bgColor
	FlxG.camera.bgColor = 0xFF000000;
	//icon window
	//window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconGame'))));
}

function destroy(){
	FlxG.camera.bgColor = 0xFF000000;
}

FlxG.save.data.DevMode ??= true;
FlxG.save.data.DevModeTracing ??= false;

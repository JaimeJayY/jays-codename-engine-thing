import flixel.util.FlxTimer;

var phonkSound:FlxSound;

function create(){
	phonkSound = FlxG.sound.load(Paths.sound('phonk' + FlxG.random.int(1, 5)), 0.7);
	phonkSound.play();
	var skullEmoji:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('skull' + FlxG.random.int(1, 8)));
	add(skullEmoji);
	skullEmoji.antialiasing = true;
	skullEmoji.cameras = [PlayState.instance.camHUD];
	skullEmoji.screenCenter(0x11);
	skullEmoji.y += 100;
	skullEmoji.scale.x = 1.5;
	skullEmoji.scale.y = 1.5;
	FlxTween.tween(skullEmoji.scale, { x: 1, y: 1 }, 0.5, {ease: FlxEase.circOut});
	FlxTween.shake(skullEmoji, 0.05, 1, FlxAxes.XY, { ease: FlxEase.circOut});
	PlayState.instance.camGame.shake(0.02,0.5);
	PlayState.instance.camHUD.shake(0.02,0.5);

	new FlxTimer().start(3.0, ()->{ 
	close();
	phonkSound.destroy(true);
	});
}
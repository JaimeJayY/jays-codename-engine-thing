import openfl.geom.ColorTransform;

var blackscreen:FlxSprite;

function postCreate() { 
    for (event in events) {
		if (event.name == "CharacterColorChange") {
            blackscreen = new FlxSprite(-FlxG.width, -FlxG.height - 1000).makeSolid(FlxG.width * 100, FlxG.height * 100, event.params[8]);
            blackscreen.alpha = 0;
            if (gf != null){
                insert(members.indexOf(gf), blackscreen);
            } else {
                insert(members.indexOf(dad), blackscreen);
            }
        }
    }
}

function onEvent(e) {
    if (e.event.name == "CharacterColorChange") {
        var params:Array = e.event.params;

        //this for hex to rgb cuz I can't/dunno how to tween colorTransform without these
        var hexColor:FlxColor = params[2];
        var rgb:Array<Int> = [
            (hexColor >> 16) & 0xFF, // Red
            (hexColor >> 8) & 0xFF,  // Green
            (hexColor & 0xFF)        // Blue
        ];

        var hexColorBF:FlxColor = boyfriend.iconColor;
        var rgbboyfriend:Array<Int> = [
            (hexColorBF >> 16) & 0xFF, // Red
            (hexColorBF >> 8) & 0xFF,  // Green
            (hexColorBF & 0xFF)        // Blue
        ];

        var hexColorDad:FlxColor = dad.iconColor;
        var rgbdad:Array<Int> = [
            (hexColorDad >> 16) & 0xFF,// Red
            (hexColorDad >> 8) & 0xFF, // Green
            (hexColorDad & 0xFF)       // Blue
        ];

        var hexColorGF:FlxColor = gf.iconColor;
        var rgbgf:Array<Int> = [
            (hexColorGF >> 16) & 0xFF, // Red
            (hexColorGF >> 8) & 0xFF,  // Green
            (hexColorGF & 0xFF)        // Blue
        ];

        //the event code itself
        if (params[0] == false) {
            if (params[1] == false) {
                if (params[3] == false) { 
                    boyfriend.colorTransform.color = params[2];
                    dad.colorTransform.color = params[2];
                    if (gf != null) gf.colorTransform.color = params[2];
                } else {
                    FlxTween.tween(boyfriend.colorTransform, {redOffset: rgb[0], greenOffset: rgb[1], blueOffset: rgb[2], redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                    FlxTween.tween(dad.colorTransform, {redOffset: rgb[0], greenOffset: rgb[1], blueOffset: rgb[2], redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                    if (gf != null){
                    FlxTween.tween(gf.colorTransform, {redOffset: rgb[0], greenOffset: rgb[1], blueOffset: rgb[2], redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                    }
                }
            } else {
                if (params[3] == false) {
                    boyfriend.colorTransform.color = boyfriend.iconColor;
                    dad.colorTransform.color = dad.iconColor;
                    if (gf != null) gf.colorTransform.color = gf.iconColor;
                } else {
                    FlxTween.tween(boyfriend.colorTransform, {redOffset: rgbboyfriend[0], greenOffset: rgbboyfriend[1], blueOffset: rgbboyfriend[2], redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                    FlxTween.tween(dad.colorTransform, {redOffset: rgbdad[0], greenOffset: rgbdad[1], blueOffset: rgbdad[2], redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                    if (gf != null){
                    FlxTween.tween(gf.colorTransform, {redOffset: rgbgf[0], greenOffset: rgbgf[1], blueOffset: rgbgf[2], redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                    }
                }
            }

            if (params[7] == true) {
                if (params[3] == false) {
                    blackscreen.alpha = 1;
                } else {
                    FlxTween.tween(blackscreen, {alpha: 1}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                }
            }
        } else {
            if (params[3] == false) {
                blackscreen.alpha = 0;
                boyfriend.colorTransform = new ColorTransform();
                dad.colorTransform = new ColorTransform();
                if (gf != null) gf.colorTransform = new ColorTransform();
            } else {
                FlxTween.tween(blackscreen, {alpha: 0}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                FlxTween.tween(boyfriend.colorTransform, {redOffset: 0, greenOffset: 0, blueOffset: 0, redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                FlxTween.tween(dad.colorTransform, {redOffset: 0, greenOffset: 0, blueOffset: 0, redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                if (gf != null){
                FlxTween.tween(gf.colorTransform, {redOffset: 0, greenOffset: 0, blueOffset: 0, redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1}, (params[4] == null ? 4 : params[4]), {ease: CoolUtil.flxeaseFromString(params[5], params[6])});
                }
            }
        }
    }
}
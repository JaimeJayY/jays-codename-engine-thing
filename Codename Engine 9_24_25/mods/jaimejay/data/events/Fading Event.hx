//a

var _eventName = "Fading Event";

var fadeSprite = new FlxSprite().makeGraphic(FlxG.width*2, FlxG.height*2, 0xFF000000);
function postCreate() {
    fadeSprite.screenCenter();
    fadeSprite.scrollFactor.set();
    fadeSprite.camera = camHUD;
    fadeSprite.alpha = 0;
    add(fadeSprite);

    for (event in events) {
        if (event.name != _eventName) continue;
        if (event.time > 10) continue;
        onEvent({event: event});
        events.remove(event);
        break;
    }
}

var fadingTween:FlxTween;
function onEvent(e) {
    var event = e.event;
    if (event.name != _eventName) return;

    var params = event.params;
    var color = params[0];
    var alpha = params[1];
    var time = params[2];
    var instant = params[3];
    var easeMode = params[4];
    var easeType = params[5];
    var hudType = params[6];
    
    switch (hudType) {
        case "camGame": fadeSprite.camera = camGame;
        default: fadeSprite.camera = camHUD;
    }

    if (time <= 0 || instant) return fadeSprite.alpha = alpha;
    
    var _ease = CoolUtil.flxeaseFromString(easeMode, easeType);
    fadingTween?.cancel();
    fadingTween = FlxTween.tween(fadeSprite, {alpha: alpha}, (Conductor.crochet*0.001)*time, {ease: _ease});
}

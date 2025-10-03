//a

var moveCameraTween:FlxTween;

function onEvent(e) {
    var event = e.event;
    if (event.name != "Camera Movement") return;
    var params = event.params;

    var cameraTarget = params[0];
    var instant = params[1];

    var easeTime_beats = params[2];
    var easeMode = params[3];
    var easeType = params[4];
    
    var _ease = CoolUtil.flxeaseFromString(easeMode, easeType);

    var cameraToFocus = PlayState.instance.strumLines.members[cameraTarget]?.characters[0]?.getCameraPosition() ?? null;
    if (cameraToFocus == null) return;
    
    if (instant) return FlxG.camera.focusOn(cameraToFocus);

    if (easeTime_beats > 0) {
        moveCameraTween?.cancel();
        moveCameraTween = FlxTween.tween(camFollow, {x: cameraToFocus.x, y: cameraToFocus.y}, (Conductor.crochet / 1000) * easeTime_beats, {ease: _ease});
    }
}

function onCameraMove(e) {
    if (moveCameraTween == null || !moveCameraTween.active) return;
    e.cancel();
}
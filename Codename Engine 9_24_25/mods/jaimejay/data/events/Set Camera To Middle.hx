//a

var _eventName = "Set Camera To Middle";

function postCreate() {
    for (event in events) {
        if (event.name != _eventName || event.time > 10) continue;
        onEvent({event: event});
        events.remove(event);
    }
}

var _useEvent = false;
var _instant = false;

var cameraTarget_1 = null;
var cameraTarget_2 = null;
var value = 0.5;

var cameraMovementTween:FlxTween;

function onEvent(e) {
    var event = e.event;
    if (event.name == "Camera Movement") return _useEvent = false;
    if (event.name != _eventName) return;
    var params = event.params.copy();
    var target1 = params.shift();
    var target2 = params.shift();

    value = params.shift();
    _instant = params.shift();

    cameraTarget_1 = PlayState.instance.strumLines.members[target1]?.characters[0]?.getCameraPosition() ?? null;
    cameraTarget_2 = PlayState.instance.strumLines.members[target2]?.characters[0]?.getCameraPosition() ?? null;
    if (cameraTarget_1 == null || cameraTarget_2 == null) return _useEvent = false;
    _useEvent = true;

    if (_instant) return;

    var easeTime_beats = params.shift();
    if (easeTime_beats <= 0) return;

    var easeMode = params.shift();
    var easeType = params.shift();
    var _ease = CoolUtil.flxeaseFromString(easeMode, easeType);

    var posX = FlxMath.lerp(cameraTarget_1.x, cameraTarget_2.x, value);
    var posY = FlxMath.lerp(cameraTarget_1.y, cameraTarget_2.y, value);

    cameraMovementTween?.cancel();
    cameraMovementTween = FlxTween.tween(camFollow, {x: posX, y: posY}, (Conductor.crochet / 1000) * easeTime_beats, {ease: _ease});
}

// used with `ui_notecam.hx` in `songs/`
function onCameraNoteMove(e, addon) {
    if (!_useEvent) return;

    e.position.x = FlxMath.lerp(cameraTarget_1.x, cameraTarget_2.x, value) + addon.x;
    e.position.y = FlxMath.lerp(cameraTarget_1.y, cameraTarget_2.y, value) + addon.y;

    if (_instant) {
        FlxG.camera.focusOn(e.position);
        _instant = false;
    }
}

function onCameraMove(e) {
    if (cameraMovementTween == null || !cameraMovementTween.active) return;
    e.cancel();
}
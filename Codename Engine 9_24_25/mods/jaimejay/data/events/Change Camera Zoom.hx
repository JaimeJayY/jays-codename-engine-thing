//a
import funkin.editors.charter.Charter;
import funkin.options.Options;

/*

    Hey so this is still kind of buggy, but if you find an issue, pls DM me on Discord (@itsljcool)

*/

var _eventName = "Change Camera Zoom";

var zoomSnapshot:Float = 0;
function postCreate() {
    zoomSnapshot = FlxG.camera.zoom = defaultCamZoom;
    camZooming = true;

    if (Charter.startHere) {
		for (event in events) {
			if (event.name != _eventName) continue;
			if (event.time < Charter.startTime) event.params[6] = 0;
		}
	}

    for (event in events) {
        if (event.name != _eventName) continue;
        if (event.time > 10) continue;
        onEvent({event: event});
        events.remove(event);
    }
}

var zoomTween:FlxTween;
function onEvent(e) {
    var event = e.event;
    if (event.name != _eventName) return;
    var params = event.params;

    var isInstant = params[0];
    var additive = params[1];
    var amount = params[2];
    var fastNegative = params[3];
    var takeSnapshot = params[4];
    var resetToSnapshot = params[5];

    var timeBeats = params[6];
    var easeMode = params[7];
    var easeType = params[8];

    var _ease = CoolUtil.flxeaseFromString(easeMode, easeType);

    if (resetToSnapshot) {
        amount = zoomSnapshot;
        additive = false;
    }
    
    if (fastNegative) amount *= -1;
    
    var zoomValue = defaultCamZoom;

    if (additive) zoomValue += amount;
    else zoomValue = amount;
    
    if (takeSnapshot) zoomSnapshot = zoomValue;

    if (timeBeats > 0 && !isInstant) {
        var _prevCamZooming = camZooming;
        var _update = () -> {
            camZooming = false;
            defaultCamZoom = FlxG.camera.zoom = zoomValue;
			camHUD.zoom = lerp(camHUD.zoom, defaultHudZoom, camHUDZoomLerp);
        };
        zoomTween?.cancel();
        zoomTween = FlxTween.tween(FlxG.camera, {zoom: zoomValue}, Conductor.crochet*(timeBeats*0.001), {ease: _ease, onUpdate: _update, onComplete: () -> {
            _update();
            camZooming = _prevCamZooming;
        }});
        return;
    }
    defaultCamZoom = zoomValue;
    if (isInstant) FlxG.camera.zoom = defaultCamZoom;

}

function beatHit(curBeat) {
    if (zoomTween == null) return;
    if (Options.camZoomOnBeat && zoomTween.active && FlxG.camera.zoom < maxCamZoom && curBeat % camZoomingInterval == 0) {
        FlxG.camera.zoom += 0.015 * camZoomingStrength;
        camHUD.zoom += 0.03 * camZoomingStrength;
    }
}
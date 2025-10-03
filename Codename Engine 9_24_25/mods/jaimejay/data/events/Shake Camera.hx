//a
import flixel.util.FlxAxes;

var _eventName = "Shake Camera";

function onEvent(e) {
    var event = e.event;
    if (event.name != _eventName) return;
    var params = event.params.copy();

    var beatsToTime = params.shift();

    var cameraOption = params.shift();
    var shakeCams = [];
    switch(cameraOption) {
        case "camGame": shakeCams.push(camGame);
        case "camHUD": shakeCams.push(camHUD);
        default: shakeCams = FlxG.cameras.list;
    }

    var intensity = params.shift();
    var duration = params.shift();

    var forceShake = params.shift();

    var shakeAxes = params.shift();
    var _shakeAxes = switch(shakeAxes) {
        case "X": FlxAxes.X;
        case "Y": FlxAxes.Y;
        default: FlxAxes.XY;
    }

    // the null param is for the `onComplete` callback, which we don't care about
    for (cam in shakeCams) cam.shake(intensity, ((!beatsToTime) ? (Conductor.crochet*0.001) * duration : duration), null, forceShake, _shakeAxes);
}
//a
var _eventName = "Set Character Camera Offset";
import funkin.backend.system.Logs;

var _characterSnapshots = [];
function postCreate() {
    for (strumline in PlayState.instance.strumLines.members) {
        var snaps = [];
        for (character in strumline.characters) snaps.push({x: character?.cameraOffset?.x ?? 0, y: character?.cameraOffset?.y ?? 0});
        _characterSnapshots.push(snaps);
    }

    for (e in events) {
        if (_eventName != e.name || e.time > 10) continue;
        onEvent({event: e});
        events.remove(e);
    }
}


var _offsetsTween:Map<Int, Dynamic> = [];

function onEvent(e) {
    var event = e.event;
    if (event.name != _eventName) return;

    // params as variables
    var params = event.params;
    var strumLine = params[0];
    var character = params[1];

    var amountX = params[2];
    var amountY = params[3];
    var additive = params[4];

    var takeSnapshot = params[5];
    var resetToSnapshot = params[6];

    var easeTime_beats = params[7];
    var easeMode = params[8];
    var easeType = params[9];
    
    var _ease = CoolUtil.flxeaseFromString(easeMode, easeType);

    var characterRef = null;
    try {
        characterRef = PlayState.instance.strumLines.members[strumLine].characters[character];
        if (characterRef == null) throw "Character does not exist!";
    } catch (e:Error) {
        Logs.traceColored([
            Logs.logText("[LJ Event Pack] ", 10),
            Logs.logText("Strumline ", -1), Logs.logText("Index "+strumLine, 12),
            Logs.logText(" with Character ", -1), Logs.logText("Index "+character, 12),
            Logs.logText(" does not exist! Not applying offset.", -1),
        ], 2);
        return;
    }

    var _charSnap = {x: 0, y: 0};
    try {
        _charSnap = _characterSnapshots[strumLine][character];
    } catch (e:Error) {
        Logs.traceColored([
            Logs.logText("[LJ Event Pack] ", 10),
            Logs.logText("Strumline ", -1), Logs.logText("Index "+strumLine, 12),
            Logs.logText(" with Character ", -1), Logs.logText("Index "+character, 12),
            Logs.logText(" has no snapshot! Defaulting to ", -1), Logs.logText("0, 0", 14),
        ], 2);
    }

    if (takeSnapshot) {
        _charSnap.x = characterRef.cameraOffset.x;
        _charSnap.y = characterRef.cameraOffset.y;
        _characterSnapshots[strumLine][character] = _charSnap;
    }

    if (easeTime_beats > 0) {
        // cool trick right?
        var _tweenX = (!resetToSnapshot) ? ((additive) ? characterRef.cameraOffset.x + amountX : amountX) : _charSnap.x;
        var _tweenY = (!resetToSnapshot) ? ((additive) ? characterRef.cameraOffset.y + amountY : amountY) : _charSnap.y;

        if (_offsetsTween.exists(strumLine)) _offsetsTween.get(strumLine).cancel();

        var tween = FlxTween.tween(characterRef.cameraOffset, {x: _tweenX, y: _tweenY}, (Conductor.crochet / 1000) * easeTime_beats, {ease: _ease});
        _offsetsTween.set(strumLine, tween);
    } else {
        if (resetToSnapshot) characterRef.cameraOffset.set(_charSnap.x, _charSnap.y);

        if (additive) {
            characterRef.cameraOffset.x += amountX;
            characterRef.cameraOffset.y += amountY;
        } else characterRef.cameraOffset.set(amountX, amountY);
    }
}
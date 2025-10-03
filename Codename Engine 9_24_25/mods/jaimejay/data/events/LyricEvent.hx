//a

import flixel.text.FlxTextBorderStyle;
import funkin.backend.scripting.events.CancellableEvent;

// This was used in Pillar Funkin, not mofidied since Scary Fools Update.
// Writen by ItsLJcool
// Calling the event pops the stack from the `json` and shows the text. Makes it easier to debug and change text.

var song = PlayState.SONG.meta.name.toLowerCase();

public var lyicsEvent:FlxText;
var newCam:FlxCamera;
var jsonData = [];
function postCreate() {
    var lyricEvent = new CancellableEvent();
    lyricEvent.data.path = Paths.getPath("songs/" + song + "/lyric.json");

    var event = PlayState.instance.scripts.event("onLyricEventCreate", lyricEvent);
    if (event.cancelled) return;

    var lyricPath = event.data.path;
    if (!Assets.exists(lyricPath)) return;

    newCam = new FlxCamera();
    newCam.bgColor = 0;
    FlxG.cameras.add(newCam, false);

    lyicsEvent = new FlxText(0,0, 0, "Insert Lyric Text lol", 32);
    // lyicsEvent.font = Paths.font("Funkin - No Outline.ttf"); // set custom font here ig
    lyicsEvent.setFormat(lyicsEvent.font, 32, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
    lyicsEvent.borderSize = 2;
    lyicsEvent.screenCenter();
    lyicsEvent.y = FlxG.height - lyicsEvent.height - 50;
    lyicsEvent.camera = newCam;
    lyicsEvent.alpha = 0;
    lyicsEvent.antialiasing = true;
    add(lyicsEvent);
    
    jsonData = Json.parse(Assets.getText(lyricPath));
}

var lyricFadeIn:FlxTween;
var lyricFadeOut:FlxTween;
function onEvent(e) {
    if (jsonData.length <= 0) return;
    var event = e.event;
    if (event.name != "LyricEvent") return;
    var data = jsonData.shift();
    var params = event.params;

    var text = StringTools.trim(data?.text ?? "");

    var stepsToBeats = params[0];
    var fadeIn_Time = params[1];
    var fadeOut_Time = params[2];

    var fadeIn_easeType = params[3];
    var fadeIn_easeMode = params[4];

    var useFadeInParams = params[5];

    var fadeOut_easeType = params[6];
    var fadeOut_easeMode = params[7];

    if (!stepsToBeats && (fadeIn_Time > 0 || fadeOut_Time > 0)) {
        fadeIn_Time *= 0.25;
        fadeOut_Time *= 0.25;
    }
    
    var borderColor = FlxColor.fromString(data?.border?.color ?? "#000000");
    var borderSize = data?.border?.size ?? 2;

    var fadeIn_ease = CoolUtil.flxeaseFromString(fadeIn_easeType, fadeIn_easeMode);

    var _lyricEvent = new CancellableEvent();
    _lyricEvent.data = {
        text: text, // add more if you want to later ig
        textObject: lyicsEvent,
        _data: data,
    };

    var event = PlayState.instance.scripts.event("onLyricEventTextUpdate", _lyricEvent);

    if (fadeIn_Time <= 0) lyicsEvent.alpha = 1;
    else {
        lyricFadeIn?.cancel();
        lyricFadeIn = FlxTween.tween(lyicsEvent, {alpha: 1}, (Conductor.crochet / 1000)*fadeIn_Time, {ease: fadeIn_ease});
    }
    lyicsEvent.text = text;
    lyicsEvent.color = FlxColor.fromString(data?.color ?? "#FFFFFF");
    lyicsEvent.screenCenter();
    lyicsEvent.y = FlxG.height - lyicsEvent.height - 50;
    lyicsEvent.setBorderStyle(FlxTextBorderStyle.OUTLINE, borderColor, borderSize);

    var fadeOut_ease = (useFadeInParams) ? fadeIn_ease : CoolUtil.flxeaseFromString(fadeOut_easeType, fadeOut_easeMode);
    lyricFadeOut?.cancel();
    if (fadeOut_Time <= 0) return;
    lyricFadeOut = FlxTween.tween(lyicsEvent, {alpha: 0}, (Conductor.crochet/1000)*1.5, {ease: fadeOut_ease, startDelay: (Conductor.crochet / 1000)*fadeOut_Time});
}
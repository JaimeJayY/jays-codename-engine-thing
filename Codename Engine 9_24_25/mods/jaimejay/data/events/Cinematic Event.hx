//a
import funkin.editors.charter.Charter;
import funkin.options.Options;

var _eventName = "Cinematic Event";

// percent at 1 is the middle of the screen, so both at 1 will be covering the screen
// "__color" insn't the actual color, its for internal tweening
var data = [
    {percent: 0, alpha: 1, color: 0xFF000000, __color: 0xFF000000},
    {percent: 0, alpha: 1, color: 0xFF000000, __color: 0xFF000000},
];

function postCreate() {

    var bar = new FlxSprite().makeSolid(FlxG.width, FlxG.height*0.5, 0xFFFFFFFF);
    bar.screenCenter();
    bar.scrollFactor.set();
    bar.camera = camHUD;
    bar.onDraw = (spr:FlxSprite) -> {
        for (i=>d in data) {
            spr.color = d.color;
            spr.alpha = d.alpha;
            spr.y = (i == 1) ? FlxMath.lerp(FlxG.height, FlxG.height - spr.height, d.percent) : FlxMath.lerp(-spr.height, 0, d.percent);
            spr.draw();
        }
    };
    insert(members.indexOf(strumLines)-1, bar);
}

var topTween:FlxTween;
var bottomTween:FlxTween;
function onEvent(e) {
    var event = e.event;
    if (event.name != _eventName) return;
    
    var params = event.params.copy();

    // never thought about using shift() but it's so much easier to manage the variables :sob:

    var stepsToBeats = params.shift(); // Boolean
    var conductorToTime = params.shift(); // Boolean

    var top_quickHeight = params.shift(); // String
    var top_height = params.shift(); // Float (Percentage)
    var top_color = params.shift(); // Color
    var top_alpha = params.shift(); // Float (Alpha)

    var bottomCopiesTop = params.shift(); // Boolean

    var bottom_quickHeight = params.shift();  // String
    var bottom_height = params.shift(); // Float (Percentage)
    var bottom_color = params.shift(); // Color
    var bottom_alpha = params.shift(); // Float (Alpha)

    if (bottomCopiesTop) {
        bottom_quickHeight = top_quickHeight;
        bottom_height = top_height;
        bottom_color = top_color;
        bottom_alpha = top_alpha;
    }

    var timeBeats = params.shift(); // Float
    var easeMode = params.shift(); // String
    var easeType = params.shift(); // String
    
    var _ease = CoolUtil.flxeaseFromString(easeMode, easeType);

    if (!stepsToBeats && timeBeats > 0 && !conductorToTime) timeBeats *= 0.25;

    var _top = quickHeight(top_quickHeight, top_height);
    var _bottom = quickHeight(bottom_quickHeight, bottom_height);
    

    if (timeBeats <= 0) {
        data[0].percent = _top;
        data[1].percent = _bottom;

        data[0].color = top_color;
        data[1].color = bottom_color;

        data[0].alpha = top_alpha;
        data[1].alpha = bottom_alpha;
    } else {
        var __time = (conductorToTime) ? timeBeats : (Conductor.crochet / 1000)*timeBeats;
        var _update = (idx:Int, twn:FlxTween) -> {
            var data = data[idx];
            _color = (idx == 0) ? top_color : bottom_color;
            data.color = FlxColor.interpolate(data.color, _color, twn.percent);
        };

        if (data[0].percent != _top && _top >= 0) topTween = FlxTween.tween(data[0], {percent: _top}, __time, {ease: _ease});
        if (data[0].alpha != top_alpha && top_alpha >= 0) FlxTween.tween(data[0], {alpha: top_alpha}, __time, {ease: _ease});
        if (data[0].color != top_color) FlxTween.tween(data[0], {__color: top_color}, __time, {ease: _ease, onUpdate: (twn)->_update(0, twn)});

        if (data[1].percent != _top && _bottom >= 0) FlxTween.tween(data[1], {percent: _bottom}, __time, {ease: _ease});
        if (data[1].alpha != top_alpha && bottom_alpha >= 0) FlxTween.tween(data[1], {alpha: bottom_alpha}, __time, {ease: _ease});
        if (data[1].color != bottom_color) FlxTween.tween(data[1], {__color: bottom_color}, __time, {ease: _ease, onUpdate: (twn)->_update(1, twn)});
    }
}

function quickHeight(option:String, height:Float):Float {
    switch (option) {
        case "1/8th Screen": return 0.125;
        case "1/4th Screen": return 0.25;
        case "3/4 Screen": return 0.75;
        case "Half Screen": return 0.5;
        case "Full Screen": return 1;
        case "Custom": return height/100;
    }
}
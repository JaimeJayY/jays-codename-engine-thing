var color:FlxColor;

function flash(col:FlxColor,dur:Int)
{
    
    var flash = new FlxSprite();
    flash.cameras = [camHUD];
    flash.makeGraphic(FlxG.width, FlxG.height, col);
    add(flash);
    FlxTween.tween(flash, {alpha: 0}, dur);
}

function onEvent(e:EventGameEvent)
{
    if (e.event.name == "Flash Camera")
    {
        var colors = switch(e.event.params[1]){
            case 'Black': color = FlxColor.BLACK;
            case 'Blue': color = FlxColor.BLUE;
            case 'Cyan': color = FlxColor.CYAN;
            case 'Gray': color = FlxColor.GRAY;
            case 'Lime': color = FlxColor.LIME;
            case 'Magenta': color = FlxColor.MAGENTA;
            case 'Orange': color = FlxColor.ORANGE;
            case 'Pink': color = FlxColor.PINK;
            case 'Purple': color = FlxColor.PURPLE;
            case 'Red': color = FlxColor.RED;
            case 'White': color = FlxColor.WHITE;
            case 'Yellow': color = FlxColor.YELLOW;
        };
        trace(colors);
        flash(colors,e.event.params[0]);
    }
}

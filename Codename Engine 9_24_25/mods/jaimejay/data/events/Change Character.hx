//a
var _eventName = "Change Character";

import funkin.game.Character;
import funkin.options.Options;

var charactersMap:Map<String, Dynamic> = [];
function postCreate() {
    for(i=>data in PlayState.SONG.strumLines) {
        var strumline = strumLines.members[i];

        var charPosName:String = (data.position == null) ? (switch(data.type) {
            case 0: "dad";
            case 1: "boyfriend";
            case 2: "girlfriend";
        }) : data.position;

        strumline.extra.set("__charPosName", charPosName);
    }

    for (strumlineIdx=>strumline in strumLines.members) {
        for (charIdx=>char in strumline.characters) {
            if (char == null) continue;
            charactersMap.set(char.curCharacter, {char: char, characterIdx: charIdx, strumLineIdx: strumlineIdx});
        }
    }

    for (event in events) {
        if (event.name != _eventName || !event.params[0] || charactersMap.exists(event.params[3])) continue;
        initalizeCharacter(event.params.copy());
    }
}

// IM SORRY :SOB:
function onEvent(e) {
    var event = e.event;
    if (event.name != _eventName) return;
    var _normalParams = event.params.copy();

    var data = initalizeCharacter(event.params.copy());
    var char = data.char;
    var character = data.replacingCharacter;

    if (char == character) return;
    var params = data.paramsLeft;
    
    var charIdx = _normalParams[2];
    var charName = char.curCharacter;
    
    var strumlineIdx = _normalParams[1];
    var strumline = strumLines.members[strumlineIdx];

    var offsetX = params.shift();
    var offsetY = params.shift();

    char.x += offsetX;
    char.y += offsetY;
    
    char.exists = char.active = char.visible = true;
    insert(members.indexOf(character), char);

    var icon = (!char.isPlayer) ? PlayState.instance.iconP2 : PlayState.instance.iconP1;
    icon.setIcon(char.getIcon());

    var __healthBar = PlayState.instance.healthBar;
    if (__healthBar != null && Options.colorHealthBar) {
        var leftColor = dad.iconColor;
        var rightColor = boyfriend.iconColor;
        switch(strumlineIdx % 2) {
            case 0: leftColor = char.iconColor;
            case 1: rightColor = char.iconColor;
        }
		__healthBar.createFilledBar(leftColor, rightColor);
        __healthBar.updateBar();
    }
    
    character.exists = character.active = character.visible = false;
    remove(character, true);
    strumline.characters[charIdx] = char;
}

function initalizeCharacter(params:Array<Dynamic>) {
    var _precache = params.shift();

    var strumlineIdx = params.shift();
    var strumline = strumLines.members[strumlineIdx];

    var charIdx = params.shift();
    var character = strumline.characters[charIdx];

    var charName = params.shift();
    var char = preloadCharacter(charName, charIdx, strumlineIdx);

    return {char: char, paramsLeft: params, replacingCharacter: character};
}

function preloadCharacter(charName:String, characterIdx:Int, strumLineIdx:Int) {
    if (charactersMap.exists(charName)) return charactersMap.get(charName).char;
    
    var strumLine = strumLines.members[strumLineIdx];
    var charPosName:String = strumLine.extra.get("__charPosName");
    
    var _stage = PlayState.instance.stage;

    var char = new Character(0, 0, charName, _stage.isCharFlipped(_stage.characterPoses[charName] != null ? charName : charPosName, (strumLineIdx == 1)));
    _stage.applyCharStuff(char, charPosName, characterIdx);
    char.cameraOffset.x += _stage?.characterPoses[charPosName]?.camxoffset;
    char.cameraOffset.y += _stage?.characterPoses[charPosName]?.camyoffset;

    char.updateHitbox();
    char.playAnim('idle');

    charactersMap.set(char.curCharacter, {char: char, characterIdx: characterIdx, strumLineIdx: strumLineIdx});
    add(char);

    // Rodney's code for precaching characters
    try {
        for (c in char.cameras) char.drawComplex(c);
    }
    catch(e:Dynamic) {
        trace('drawComplex didn\'t work this time for some reason');
    }

    remove(char, true);
    char.exists = char.active = char.visible = false;

    return char;
}
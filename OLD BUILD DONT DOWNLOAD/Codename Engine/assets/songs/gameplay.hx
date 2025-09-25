//made this to record gameplay of my mod for a youtube video. most people would do player.cpu = true;
//but then the hud would expose you for using botplay. this updates the score and combo counter

//credits to sen for starting off the code. i finished most of it and i think someone from the definitive experience team edited it a bit

function update(_){
    if (FlxG.keys.justPressed.B) player.cpu = !player.cpu;
}

function onNoteHit(e) {
    if (e.note.strumLine == strumLines.members[1] && !e.note.isSustainNote) {
        e.showSplash = true;
        combo += 1;
        songScore += 300;
    }
}


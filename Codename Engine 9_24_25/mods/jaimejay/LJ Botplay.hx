//original code by LJ, edited by Malloy

// Configurable variables (edit these as needed)
public static var botplay:Bool = true; // default ON
public static var toggleKey:String = "B"; // keybind
public static var blockInputs:Bool = true; // cancel inputs while botplay

var _allowedGitaroo:Bool = allowGitaroo;

function update(elapsed) {
    if (FlxG.keys.justPressed[ toggleKey ]) {
        botplay = !botplay;
        canDie = !botplay;
        if (_allowedGitaroo) allowGitaroo = !botplay;
    }
    playerStrums.forEach((strum) -> { strum.cpu = botplay; });
}

function postCreate() {
    strumLines.forEach(function(strum) {
        if (strum.cpu) return;
        strum.onNoteUpdate.add(updateNote);
    });
}

function onInputUpdate(event) {
    if (blockInputs && botplay) event.cancel();
}

function updateNote(event) {
    if (!botplay) return;

    var daNote:Note = event.note;
    if (!daNote.avoid && !daNote.wasGoodHit && daNote.strumTime < Conductor.songPosition)
        PlayState.instance.goodNoteHit(daNote.strumLine, daNote);
}

function onNoteHit(e) {
    if (e.note.strumLine == strumLines.members[1] && !e.note.isSustainNote) {
        e.showSplash = true;
    }
}

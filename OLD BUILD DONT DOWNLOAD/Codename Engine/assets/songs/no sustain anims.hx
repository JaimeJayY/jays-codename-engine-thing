// okay
import haxe.ds.ObjectMap;

var frozenCharacters:ObjectMap<Character, Bool> = new ObjectMap();

function onNoteHit(event) {
	for (char in event.characters) {
		if (event.note.isSustainNote) {
			if (
				(
					char.animation.exists(char.singAnims[event.direction] + event.animSuffix + '-loop') ||
					char.animation.exists(char.singAnims[event.direction] + '-loop')
				) ||
				StringTools.endsWith(char.getAnimName(), '-loop')
			) {
				if (StringTools.endsWith(char.getAnimName(), '-loop')) {
					event.animCancelled = true;
					char.lastHit = Conductor.songPosition;
				} else if (!event.animCancelled)
					event.animSuffix += '-loop';
				continue;
			}
			frozenCharacters.set(char, true);
		}

		if (event.note.animation.name == 'holdend')
			frozenCharacters.set(char, false);
	}
}

function postUpdate(elapsed:Float) {
	for (i in 0...strumLines.members.length) {
		var char = strumLines.members[i].characters[0];

		if (frozenCharacters.get(char) && char.animation.curAnim != null) char.animation.curAnim.paused = true;
		else if (char.animation.curAnim != null) char.animation.curAnim.paused = false;
	}
}

function onPlayerMiss(event)
	for (char in event.characters)
		frozenCharacters.set(char, false);
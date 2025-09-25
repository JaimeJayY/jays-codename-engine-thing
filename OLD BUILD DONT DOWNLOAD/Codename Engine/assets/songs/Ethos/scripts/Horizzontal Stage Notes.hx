// Script by Nex_isDumb
var daX:Float = -200, daY:Float = 600;  // Change these to move them around and position them correctly
var limitAdder:Float = 1400; // If the notes spawn too late or early mess with this value

function onStrumCreation(event) if (event.player == 0) event.cancelAnimation();
function onPostStrumCreation(event) if (event.player == 0) {
	event.strum.angle = -90;
	event.strum.setPosition(dad.x + event.strum.y + daX, -event.strum.x + daY);
	event.strum.scrollFactor.set(1, 1);
}

function postCreate() if ((dadNotes = strumLines?.members[0]) != null) {
	dadNotes.notes.limit += limitAdder;
	dadNotes.cameras = [camGame];

	var gfIndex = members.indexOf(gf);
	remove(strumLines);
	insert(gfIndex > -1 ? gfIndex : members.indexOf(dad), strumLines);
}
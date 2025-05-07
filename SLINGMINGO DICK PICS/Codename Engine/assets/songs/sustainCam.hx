var camSustain:HudCamera;

function create()
{
	camSustain = new HudCamera();
	camSustain.bgColor = 0x000000;

	FlxG.cameras.remove(camHUD, false);
	FlxG.cameras.add(camSustain, false);
	FlxG.cameras.add(camHUD, false);

}

function onNoteCreation(event:NoteCreationEvent)
{
	var note:Note = event.note;
	if (!note.isSustainNote)
		return;

	note.cameras = [camSustain];
}

function update(elapsed:Float)
{
	if (camSustain != null)
	{
		if (camSustain.zoom != camHUD.zoom)
			camSustain.zoom = camHUD.zoom;
		if (camSustain.alpha != camHUD.alpha)
			camSustain.alpha = camHUD.alpha;
		if (camSustain.angle != camHUD.angle)
			camSustain.angle = camHUD.angle;
		if (camSustain.downscroll != camHUD.downscroll)
			camSustain.downscroll = camHUD.downscroll;
	}
}

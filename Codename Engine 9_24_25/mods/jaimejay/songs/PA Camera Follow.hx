/**
 * A recreation of the camera movement code from Pibby: Apocalypse.
 * @author Zenith
 * @author ADA_Funni
 * @see https://gamebanana.com/wips/73842
 */

using StringTools;

// HUD Options

// Should the HUD rotate with the camera?
// Only applies if `rotationEnabled == true`.
public var hudFollow:Bool = false;

// How much the HUD rotates when a character is singing.
// Only applies if `rotationEnabled == true`.
public var hudFollowOffset:Float = 5;

// Game Options

// Should the camera's X and Y position be moved?
public var movementEnabled:Bool = true;

// Should the camera's angle be moved?
public var rotationEnabled:Bool = true;

// How much the camera moves when a character is singing.
public var camFollowOffset:Float = 15;

// Ignore "Move Camera" events?
public var isForcedCam:Bool = false;

// The Code

// This is a messy system, but it means less code for me, so I'll leave it be.
function postUpdate(elapsed:Float) {
	var char = strumLines.members[curCameraTarget].characters[0];
       var animName = char.getAnimName();

       // If `char` ain't singing, then go back to normal.
       if (!animName.contains("sing")) doScrollStuff(0, 0, 0);
       
       // If `char` ain't missing, then move the camera.
       if (!animName.contains("miss") && animName.contains("sing")) {
              if (animName.startsWith("singLEFT")) doScrollStuff(-camFollowOffset, 0, 1);
              else if (animName.startsWith("singDOWN")) doScrollStuff(0, camFollowOffset, 0);
              else if (animName.startsWith("singUP")) doScrollStuff(0, -camFollowOffset, 0);
              else if (animName.startsWith("singRIGHT")) doScrollStuff(camFollowOffset, 0, -1);
       }
}

// Moves the camera.
function doScrollStuff(x:Float, y:Float, angle:Float) {
	if (movementEnabled) camGame.targetOffset.set(x, y);
	if (rotationEnabled) camGame.angle = FlxMath.lerp(camGame.angle, angle, camGame.followLerp * camFollowOffset / 30);

	if (rotationEnabled && hudFollow) camHUD.angle = FlxMath.lerp(camHUD.angle, angle, camHUD.followLerp * hudFollowOffset / 30);
}

// This function is here for getting the `isForcedCam` variable to work.
function onCameraMove(e:CamMoveEvent) {
	if (isForcedCam)
		e.cancel();
}
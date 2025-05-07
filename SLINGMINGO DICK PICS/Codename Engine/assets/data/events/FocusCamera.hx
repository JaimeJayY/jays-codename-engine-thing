import flixel.camera.FlxCameraFollowStyle;

var LockOn:Bool = false;
var camFollowTween:FlxTween;

function onEvent(_) {
	switch (_.event.name){
		case 'FocusCamera':
            var durationForTween = (Conductor.stepCrochet / 1000) * _.event.params[3];
            var easeTweenType = _.event.params[4];
            curCameraTarget = _.event.params[0];
            var camTargetX = strumLines.members[curCameraTarget].characters[0].getCameraPosition().x + (_.event.params[1] == null ? 0 : _.event.params[1]);
            var camTargetY = strumLines.members[curCameraTarget].characters[0].getCameraPosition().y + (_.event.params[2] == null ? 0 : _.event.params[2]);

            LockOn = true;

            FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 10);
            
            if(camFollowTween != null) camFollowTween.cancel();
            switch(easeTweenType.toUpperCase()){
                case "CLASSIC":
                    camFollow.setPosition(camTargetX, camTargetY);
                    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
                case "INSTANT": 
                    camFollow.setPosition(camTargetX, camTargetY);
                    FlxG.camera.focusOn(camFollow.getPosition());
                default: camFollowTween = FlxTween.tween(camFollow, {x: camTargetX, y: camTargetY}, durationForTween, {ease: Reflect.field(FlxEase, easeTweenType)});
            }
        case "Camera Movement":
            if(camFollowTween != null) camFollowTween.cancel();
            if(LockOn){
                LockOn = false;
                FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
            }
    }
}

function onCameraMove(event){
    switch(LockOn){
        case true: event.cancelled = true;
        case false: event.cancelled = false;
    }
}
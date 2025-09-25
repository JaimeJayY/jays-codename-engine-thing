/* 
trferret's super cinematic bar event
if you could credit me that would be awesome please and thanks
*/

function postCreate() {
	topBar = new FlxSprite(0, -FlxG.height).makeSolid(FlxG.width * 2, FlxG.height, FlxColor.BLACK);
	bottomBar = new FlxSprite(0, FlxG.height).makeSolid(FlxG.width * 2, FlxG.height, FlxColor.BLACK);
	leftBar = new FlxSprite(-FlxG.width, 0).makeSolid(FlxG.width, FlxG.height * 2, FlxColor.BLACK);
	rightBar = new FlxSprite(FlxG.width, 0).makeSolid(FlxG.width, FlxG.height * 2, FlxColor.BLACK);

	for (i in [topBar, bottomBar, leftBar, rightBar]) {
		i.cameras = [camHUD];
		insert(members.indexOf(strumLines), i);
	}
}

function onEvent(e:EventGameEvent){
   if (e.event.name == "Cinematic Bars") {
		if (e.event.params[0] == "Top + Bottom") {
			topBar.colorTransform.color = e.event.params[3];
			bottomBar.colorTransform.color = e.event.params[3];

			if (e.event.params[4] == false) {
				topBar.y = -FlxG.height + e.event.params[2];
				bottomBar.y = FlxG.height - e.event.params[2];
			}
			else if (e.event.params[6] != null) {
				FlxTween.tween(topBar, {y: -FlxG.height + e.event.params[2]}, (Conductor.stepCrochet / 1000) * (e.event.params[5] == null ? 4 : e.event.params[5]), {ease: CoolUtil.flxeaseFromString(e.event.params[6], e.event.params[7])});
				FlxTween.tween(bottomBar, {y: FlxG.height - e.event.params[2]}, (Conductor.stepCrochet / 1000) * (e.event.params[5] == null ? 4 : e.event.params[5]), {ease: CoolUtil.flxeaseFromString(e.event.params[6], e.event.params[7])});				
			}
		}
		if (e.event.params[0] == "Left + Right") {
			leftBar.colorTransform.color = e.event.params[3];
			rightBar.colorTransform.color = e.event.params[3];

			if (e.event.params[4] == false) {
				leftBar.x = -FlxG.width + e.event.params[1];
				rightBar.x = FlxG.width - e.event.params[1];
			}
			else if (e.event.params[6] != null) {
				FlxTween.tween(leftBar, {x: -FlxG.width + e.event.params[1]}, (Conductor.stepCrochet / 1000) * (e.event.params[5] == null ? 4 : e.event.params[5]), {ease: CoolUtil.flxeaseFromString(e.event.params[6], e.event.params[7])});
				FlxTween.tween(rightBar, {x: FlxG.width - e.event.params[1]}, (Conductor.stepCrochet / 1000) * (e.event.params[5] == null ? 4 : e.event.params[5]), {ease: CoolUtil.flxeaseFromString(e.event.params[6], e.event.params[7])});
			}
		}

   }
}
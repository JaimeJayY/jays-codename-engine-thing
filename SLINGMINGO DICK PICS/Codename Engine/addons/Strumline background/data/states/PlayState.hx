function postCreate() {
    // Retrieve the saved opacity value from options
    var strumlineBGOpacity:Float = FlxG.save.data.strumlineBGOpacity;
    if (strumlineBGOpacity == null) {
        strumlineBGOpacity = 0.25; // Default to full opacity if not set
    }

    // Create the strumline background
    var strumlineBG = new FlxSprite(734, -300).makeGraphic(450, 1300, FlxColor.BLACK);
    strumlineBG.scrollFactor.set();
    strumlineBG.alpha = Math.max(0, Math.min(1.0, strumlineBGOpacity)); // Clamp between 0.1 and 1.0

    insert(members.indexOf(strumLines), strumlineBG);

    // Create another strumline background (left side)
    var strumlineBGLeft = new FlxSprite(93, -300).makeGraphic(450, 1300, FlxColor.BLACK); // Adjusted X position
    strumlineBGLeft.scrollFactor.set();
    strumlineBGLeft.alpha = Math.max(0, Math.min(1.0, strumlineBGOpacity)); // Clamp between 0.1 and 1.0

    insert(members.indexOf(strumLines), strumlineBGLeft);

    // Assign cameras to HUD elements
    for (e in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, missesTxt, accuracyTxt, strumlineBG, strumlineBGLeft])
        e.cameras = [camHUD];
}
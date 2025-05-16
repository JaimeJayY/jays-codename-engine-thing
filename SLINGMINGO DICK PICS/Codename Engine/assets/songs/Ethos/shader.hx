camHUD.addShader(new CustomShader("CRTShader"));

FlxG.camera.addShader(new CustomShader("CRTShader")); //ditto but on FlxG.camera.

FlxG.game.addShader(new CustomShader("CRTShader")); //adds a shader onto the entire game (persists between states).

sprite.shader = new CustomShader("CRTShader"); // sets a sprite's shader to a shader. (only one shader can be added per sprite)

boyfriend.shader = new CustomShader("CRTShader"); // ditto but on characters.
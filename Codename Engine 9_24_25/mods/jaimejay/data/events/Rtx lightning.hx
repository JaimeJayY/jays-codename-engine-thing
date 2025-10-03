function onEvent(event) {
  if (event.event.name == "Rtx lightning") {
    if (event.event.params[0]) {
      var char = strumLines.members[event.event.params[2]].characters[0];

      inline function randomColor():Array<Float> {
        return [for (i in 0...4) Math.fround((Math.random() * 2 - 1) * 100) / 100];
      }

      var msk:Array<Float>;
      var sat:Array<Float>;
      var lght:Array<Float>;
      var angl:Float;
      var lghtsz:Int;
      var numly:Int;
      var lysep:Int;

      if (event.event.params[1]) {
        msk = randomColor();
        sat = randomColor();
        lght = randomColor();
        angl = Math.floor(Math.random() * 360);
        lghtsz = Math.floor(Math.random() * 20) + 1;
        numly = Math.floor(Math.random() * 10) + 1;
        lysep = Math.floor(Math.random() * 5) + 1;

        trace("\n\n - - -[[ RANDOM SHADER VALUES ]] - - - ");
        trace("Top Mask Color :" + msk);
        trace("Sprite Color Configuration :" + sat);
        trace("Light Color :" + lght);
        trace("Light Angle :" + angl);
        trace("Light Size :" + lghtsz);
        trace("Number of layers :" + numly);
        trace("Layer Separation :" + lysep);
        trace("\n\n");
      } else {
        msk = event.event.params[3].split(",").map(s -> Std.parseFloat(s));
        sat = event.event.params[4].split(",").map(s -> Std.parseFloat(s));
        lght = event.event.params[5].split(",").map(s -> Std.parseFloat(s));
        angl = event.event.params[6];
        lghtsz = event.event.params[7];
        numly = event.event.params[8];
        lysep = event.event.params[9];
      }

      char.shader = new CustomShader("RTXLighting");
      char.shader.overlayColor = msk;
      char.shader.satinColor = sat;
      char.shader.innerShadowColor = lght;
      char.shader.innerShadowAngle = (angl - 90) * Math.PI / 180;
      char.shader.innerShadowDistance = lghtsz;
      char.shader.layernumbers = numly;
      char.shader.layerseparation = lysep;
    }
  }
}

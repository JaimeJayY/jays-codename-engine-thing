import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.ui.FlxSlider;
import flixel.FlxState;

FlxG.mouse.visible = true;
FlxG.mouse.enabled = true;
var bff = null;

// Shader Variables
var shaderParms = {
  mask_Color_R:0,
  mask_Color_G:0,
  mask_Color_B:0,
  mask_Color_A:0,

  sprite_Color_R:0,
 sprite_Color_G:0,
  sprite_Color_B:0,
  sprite_Color_A:0,

    light_Color_R:0,
    light_Color_G:0,
    light_Color_B:0,
    light_Color_A:0,

    light_Angle:0,
    light_Size:0,
    number_Of_Layers:0,
    layer_Separation:0

}

// Events value texts
var nalgle = 0;
var topMasCol = "0,0,0,0";
var spriteCol = "0,0,0,0";
var lightCol = "0,0,0,0";
var sizex = 0;
var numLay = 0;
var laySep = 0;


//
//      UGH IM TO LAZY TO ADD COMMENTS TO THIS
//



function postCreate() {

                var stge:FlxSprite = new FlxSprite(-600, -220); 
        stge.loadGraphic("images/stage.jpg"); 
        add(stge); 
        stge.scale.set(0.7,0.7);
        stge.camera = FlxG.camera;
        
        

         bff = new FlxSprite(500, 300); 
        bff.loadGraphic("images/bf.png"); 
        add(bff); 
        bff.scale.set(1,1);
        bff.camera = FlxG.camera;

        var playerSprite:FlxSprite = new FlxSprite(950, 0); 
        playerSprite.loadGraphic("images/event.png"); 
        add(playerSprite); 
        playerSprite.scale.set(1,1);
        playerSprite.camera = FlxG.camera;




        var slidbg:FlxSprite = new FlxSprite(-343, -353); 
        slidbg.loadGraphic("images/rgbabg.png"); 
        add(slidbg); 
        slidbg.scale.set(0.21,0.21);
        slidbg.alpha = 0.5;
        slidbg.camera = FlxG.camera;

                var slidbg2:FlxSprite = new FlxSprite(-93, -353); 
        slidbg2.loadGraphic("images/rgbabg.png"); 
        add(slidbg2); 
        slidbg2.scale.set(0.21,0.21);
        slidbg2.alpha = 0.5;
        slidbg2.camera = FlxG.camera;

                var slidbg:FlxSprite = new FlxSprite(157, -353); 
        slidbg.loadGraphic("images/rgbabg.png"); 
        add(slidbg); 
        slidbg.scale.set(0.21,0.21);
        slidbg.alpha = 0.5;
        slidbg.camera = FlxG.camera;

				bff.shader = new CustomShader("RTXLighting");
				bff.shader.overlayColor = [0, 0, 0, 0];
				bff.shader.satinColor = [0, 0, 0, 0];
				bff.shader.innerShadowColor = [1, 0, 0, 1];
				bff.shader.innerShadowAngle = (shaderParms.nalge - 90) * Math.PI / 180;
				bff.shader.innerShadowDistance = 10;
				bff.shader.layernumbers = 5;
				bff.shader.layerseparation = 1;

        var sX = 50; // slider X
        var sY = 300; // slider Y
        var sMin = 0; // slider MinValue
        var sMax = 360; // slider MaxValue
        var sW = 200; // slider width
        var sH = 30; // handle/slider height
        var sT = 20; // handle/slider thickness
 



        var topMaskR = new FlxSlider(shaderParms,"mask_Color_R",sX,200,0,1,sW,sH,sT);
topMaskR.camera =  FlxG.camera;
add(topMaskR);
        var topMaskG = new FlxSlider(shaderParms,"mask_Color_G",sX,150,0,1,sW,sH,sT);
topMaskG.camera =  FlxG.camera;
add(topMaskG);
        var topMaskB = new FlxSlider(shaderParms,"mask_Color_B",sX,100,0,1,sW,sH,sT);
topMaskB.camera =  FlxG.camera;
add(topMaskB);
        var topMaskA = new FlxSlider(shaderParms,"mask_Color_A",sX,50,-1,1,sW,sH,sT);
topMaskA.camera =  FlxG.camera;
add(topMaskA);

        var spriteColR = new FlxSlider(shaderParms,"sprite_Color_R",300,200,0,1,sW,sH,sT);
spriteColR.camera =  FlxG.camera;
add(spriteColR);
        var spriteColG = new FlxSlider(shaderParms,"sprite_Color_G",300,150,0,1,sW,sH,sT);
spriteColG.camera =  FlxG.camera;
add(spriteColG);
        var spriteColB = new FlxSlider(shaderParms,"sprite_Color_B",300,100,0,1,sW,sH,sT);
spriteColB.camera =  FlxG.camera;
add(spriteColB);
        var spriteColA = new FlxSlider(shaderParms,"sprite_Color_A",300,50,-1,1,sW,sH,sT);
spriteColA.camera =  FlxG.camera;
add(spriteColA);

        var lightColR = new FlxSlider(shaderParms,"light_Color_R",550,200,0,1,sW,sH,sT);
lightColR.camera =  FlxG.camera;
add(lightColR);
        var lightColG = new FlxSlider(shaderParms,"light_Color_G",550,150,0,1,sW,sH,sT);
lightColG.camera =  FlxG.camera;
add(lightColG);
        var lightColB = new FlxSlider(shaderParms,"light_Color_B",550,100,0,1,sW,sH,sT);
lightColB.camera =  FlxG.camera;
add(lightColB);
        var lightColA = new FlxSlider(shaderParms,"light_Color_A",550,50,-1,1,sW,sH,sT);
lightColA.camera =  FlxG.camera;
add(lightColA);

        var lightnalge = new FlxSlider(shaderParms,"light_Angle",sX,sY,sMin,sMax,350,sH,sT);
lightnalge.camera =  FlxG.camera;
add(lightnalge);
        var lightSize = new FlxSlider(shaderParms,"light_Size",sX,375,0,100,350,sH,sT);
lightSize.camera =  FlxG.camera;
add(lightSize);
        var numOfLay = new FlxSlider(shaderParms,"number_Of_Layers",sX,450,0,100,350,sH,sT);
numOfLay.camera =  FlxG.camera;
add(numOfLay);
        var laySepa = new FlxSlider(shaderParms,"layer_Separation",sX,525,0,100,350,sH,sT);
laySepa.camera =  FlxG.camera;
add(laySepa);


    topMasCol = new FunkinText(960, 105, 250, "0,0,0,0", 20);
    topMasCol.alignment = "left";
    add(topMasCol);

        spriteCol = new FunkinText(960, 165, 250, "0,0,0,0", 20);
    spriteCol.alignment = "left";
    add(spriteCol);

            lightCol = new FunkinText(960, 220, 250, "0,0,0,0", 20);
    lightCol.alignment = "left";
    add(lightCol);

        nalgle = new FunkinText(960, 278, 100, "0", 20);
    nalgle.alignment = "left";
    add(nalgle);

            sizex = new FunkinText(960, 337, 100, "0", 20);
    sizex.alignment = "left";
    add(sizex);

            numLay = new FunkinText(960, 437, 100, "0", 20);
    numLay.alignment = "left";
    add(numLay);

            laySep = new FunkinText(960, 495, 100, "0", 20);
    laySep.alignment = "left";
    add(laySep);
}


function postUpdate(elapsed:Float):Void {

bff.shader.overlayColor = [shaderParms.mask_Color_R, shaderParms.mask_Color_G, shaderParms.mask_Color_B, shaderParms.mask_Color_A];
bff.shader.satinColor = [shaderParms.sprite_Color_R, shaderParms.sprite_Color_G, shaderParms.sprite_Color_B, shaderParms.sprite_Color_A];
bff.shader.innerShadowColor = [shaderParms.light_Color_R, shaderParms.light_Color_G, shaderParms.light_Color_B, shaderParms.light_Color_A];
bff.shader.innerShadowAngle = (shaderParms.light_Angle - 90) * Math.PI / 180;
bff.shader.innerShadowDistance = shaderParms.light_Size;
bff.shader.layernumbers = shaderParms.number_Of_Layers;
bff.shader.layerseparation = shaderParms.layer_Separation;

    if (FlxG.keys.justPressed.BACKSPACE) {
        FlxG.switchState(new MainMenuState());
        CoolUtil.playMenuSFX(2);
    }

topMasCol.text = Math.round( shaderParms.mask_Color_R * 100) / 100 + "," +  Math.round( shaderParms.mask_Color_G * 100) / 100 + "," + Math.round( shaderParms.mask_Color_B * 100) / 100 + "," +  Math.round( shaderParms.mask_Color_A * 100) / 100 ;
spriteCol.text = Math.round( shaderParms.sprite_Color_R * 100) / 100 + "," +  Math.round( shaderParms.sprite_Color_G * 100) / 100 + "," + Math.round( shaderParms.sprite_Color_B * 100) / 100 + "," +  Math.round( shaderParms.sprite_Color_A * 100) / 100 ;
lightCol.text = Math.round( shaderParms.light_Color_R * 100) / 100 + "," +  Math.round( shaderParms.light_Color_G * 100) / 100 + "," + Math.round( shaderParms.light_Color_B * 100) / 100 + "," +  Math.round( shaderParms.light_Color_A * 100) / 100 ;
nalgle.text = Math.floor(shaderParms.light_Angle);
sizex.text = Math.floor(shaderParms.light_Size);
numLay.text = Math.floor(shaderParms.number_Of_Layers);
laySep.text = Math.floor(shaderParms.layer_Separation);
}


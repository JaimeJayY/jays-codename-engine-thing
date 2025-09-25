var chatBox:FlxSprite;
var CBG:FlxSprite;
var MBG:FlxSprite;
var border:FlxSprite;

function create(){
	PlayState.instance.introLength = 0.1;

	MBG = new FlxSprite();
    MBG.loadGraphic(Paths.image('stages/think/MarkBG'));
	MBG.camera = camHUD;
	insert(2, MBG);

	chatBox = new FlxSprite();
    chatBox.loadGraphic(Paths.image('stages/think/ChatBox'));
	chatBox.camera = camHUD;
	insert(0, chatBox);

	CBG = new FlxSprite();
    CBG.loadGraphic(Paths.image('stages/think/CeaserBG'));
	CBG.camera = camHUD;
	insert(0, CBG);

	border = new FlxSprite();
    border.loadGraphic(Paths.image('stages/think/Black_Border'));
	border.camera = camHUD;
	PlayState.defaultHudZoom = 0.8;

}
function onCountdown(event) event.cancel();

function postCreate(){
	boyfriend.camera = camHUD;
	dad.camera = camHUD;
	remove(boyfriend, true);
	insert(1, boyfriend);
	remove(dad, true);
	insert(6, dad);

	insert(9, border);
	remove(chatBox, true);
	insert(10, chatBox);
	dad.x += 200;
	//dad.y += 270;
	camGame.alpha = 0;
	boyfriend.flipX = false;
	//boyfriend.y += 300;
	boyfriend.y -= 60;
	camHUD.scroll.y += 100;
	boyfriend.x -= 50;
	dad.y += 700;
}
function postUpdate(){
	camHUD.zoom = 0.7;
}
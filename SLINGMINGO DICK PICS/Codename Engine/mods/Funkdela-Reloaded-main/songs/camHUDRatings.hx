function postUpdate() comboGroup.forEachAlive(function(spr) if (spr.camera != camHUD) spr.camera = camHUD);
function postCreate(){
    comboGroup.x = 560;
	comboGroup.y = 290;
}
import funkin.game.Stage;
import Xml;

var stageList = [];

function create() {
  stageList.push({
    name: PlayState.SONG.stage,
    obj: stage
  });

  for (event in PlayState.SONG.events) {
    if (event.name == "Change Stage" && event.params[0] != "") {
      var exists = false;
      for (stage in stageList) {
        if (stage.name == event.params[0]) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        var newstage = {
          name: event.params[0],
          obj: new Stage(event.params[0])
        }
        for (sprite in newstage.obj.stageSprites) {
          if (sprite == null) continue;
          sprite.visible = false;
        }
        for (xmlScript in newstage.obj.xmlImportedScripts) {
          xmlScript.getScript().active = false;
        }
        stageList.push(newstage);
        add(newstage.obj);
      }
    }
  }
  defaultCamZoom = stage.defaultZoom;
}

// some stages execute code on creation, disabling the script on create can cause their code to fail
// stages like limo or spooky break if we dont disable them on postcreate
function postCreate() {
  for (stage in stageList) {
    if (stage.name != PlayState.SONG.stage) {
      stage.obj.stageScript.active = false;
    }
  }
}


function onEvent(e) {
  if (e.event.name == "Change Stage") {
    var params = e.event.params;
    var stageName = params[0];
    if (stageName == "") return;

    for (stage in stageList) {
      var isTheStage = stage.name == stageName;
      for (sprite in stage.obj.stageSprites) {
        if (sprite == null) continue;
        sprite.visible = isTheStage;
      }
      for (xmlScript in stage.obj.xmlImportedScripts) {
        xmlScript.getScript().active = isTheStage;
      }
      if (isTheStage) {
        stage.obj.stageScript.active = true;
        FlxG.camera.zoom = defaultCamZoom;

        // === Proper character repositioning from stage data ===
        function applyPose(char:Dynamic, tag:String)
        {
            if (stage.obj.characterPoses != null && stage.obj.characterPoses.exists(tag))
            {
                var pos = stage.obj.characterPoses.get(tag);
                if (pos != null)
                {
                    if (Reflect.hasField(pos, "x")) char.x = pos.x;
                    if (Reflect.hasField(pos, "y")) char.y = pos.y;
                    if (Reflect.hasField(pos, "scrollX")) char.scrollFactor.x = pos.scrollX;
                    if (Reflect.hasField(pos, "scrollY")) char.scrollFactor.y = pos.scrollY;
                    if (Reflect.hasField(pos, "angle")) char.angle = pos.angle;
                    if (Reflect.hasField(pos, "flipX")) char.flipX = pos.flipX;
                }
            }
        }

        applyPose(dad, "dad");
        applyPose(boyfriend, "boyfriend");
        applyPose(gf, "girlfriend");

        // === Fix Character Layer Order(not working lol) ===
        remove(gf, false);
        remove(dad, false);
        remove(boyfriend, false);

        var gfIndex = getIndexBefore("gf", stage.obj);
        var dadIndex = getIndexBefore("dad", stage.obj);
        var bfIndex = getIndexBefore("bf", stage.obj);

        if (gfIndex < 0) gfIndex = members.indexOf(stage.obj) + 1;
        if (dadIndex < 0) dadIndex = gfIndex + 1;
        if (bfIndex < 0) bfIndex = dadIndex + 1;

        insert(gfIndex, gf);
        insert(dadIndex, dad);
        insert(bfIndex, boyfriend);



      } else {
        stage.obj.stageScript.active = false;
      }
    }
  }
}

// so we can get the exact index of the characters on a stage
// char must be "bf", "gf" or "dad"
function getIndexBefore(char:String, stageRef) {
  if (stageRef == null) return null;

  var xml = Xml.parse(stageRef.stageXML).firstElement().elements();
  var resultObj:Xml = null;

  var bfAliases = ["boyfriend", "bf", "player"];
  var gfAliases = ["girlfriend", "gf"];
  var dadAliases = ["dad", "opponent"];
  var characterNodes = bfAliases.concat(gfAliases).concat(dadAliases);

  var excludedNodes = ["use-extension", "extension", "ext", "ratings", "combo"];

  for (node in xml) {
    var nodeName = node.nodeName;

    if ((char == "bf" && bfAliases.contains(nodeName)) ||
        (char == "gf" && gfAliases.contains(nodeName)) ||
        (char == "dad" && dadAliases.contains(nodeName))) {
      break;
    }

    if (nodeName == "high-memory" && Options.lowMemoryMode == false) {
      for (n in node.elements()) {
        if (!excludedNodes.contains(n.nodeName)) {
          resultObj = n;
        }
      }
    }
    else if (!excludedNodes.contains(nodeName) && !characterNodes.contains(nodeName)) {
      resultObj = node;
    }
  }

  var objName = (resultObj != null) ? resultObj.get("name") : null;
  var objIndex = members.indexOf(stageRef.getSprite(objName)) + 1;
  return objIndex;
}
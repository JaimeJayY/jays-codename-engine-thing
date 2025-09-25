import funkin.backend.scripting.Script;
import funkin.backend.utils.StageUtils;

class StageChangeScript extends Script {}
  override function onStepHit(step:Int) {
    if (step == 2304) { // Change at step 128
        StageUtils.changeStage("ETHOS2");

        trace("Changing stage from ETHOS1 to ETHOS2...");

        // Change the stage
        StageUtils.changeStage("ETHOS2");
    }
}
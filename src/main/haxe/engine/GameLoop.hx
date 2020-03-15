package engine;

import js.Browser;

class GameLoop {
    private var shouldExitLoop:Bool = false;
    private var update:(Float)->Void = (timestamp)->{};

    public function new() {}

    private function tick(timestamp:Float) {
        if(shouldExitLoop)
            return;

        update(timestamp);
        Browser.window.requestAnimationFrame(tick);
    }

    public function start(update:(Float)->Void) {
        this.shouldExitLoop = false;
        this.update = update;
        tick(0);
    }

    public function stop() {
        this.shouldExitLoop = true;
        this.update = (timestamp)->{};
    }
}
package engine;

import js.Browser;

class GameLoop {
    private var shouldExitLoop:Bool = false;
    private var lastTimeStamp:Float = 0.0;
    private var update:(Float)->Void = (tickTime)->{};

    public function new() {}

    private function tick(timestamp:Float) {
        if(shouldExitLoop)
            return;

        update(timestamp - lastTimeStamp);
        lastTimeStamp = timestamp;

        Browser.window.requestAnimationFrame(tick);
    }

    public function start(update:(Float)->Void) {
        this.shouldExitLoop = false;
        this.update = update;
        this.lastTimeStamp = Browser.window.performance.now();
        tick(this.lastTimeStamp);
    }

    public function stop() {
        this.shouldExitLoop = true;
        this.lastTimeStamp = 0.0;
        this.update = (tickTime)->{};
    }
}
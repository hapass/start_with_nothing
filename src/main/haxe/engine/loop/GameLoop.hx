package engine.loop;

import lang.Debug;
import js.Browser;
import engine.loop.GameLoopObserver;

class GameLoop {
    private var shouldExitLoop: Bool;
    private var observer: GameLoopObserver;

    public function new() {}

    private function tick(timestamp: Float) {
        if(shouldExitLoop)
            return;

        Debug.assert(observer != null, "Loop observer must be set before tick.");
        observer.update(timestamp);

        Browser.window.requestAnimationFrame(tick);
    }

    public function start(observer: GameLoopObserver) {
        this.shouldExitLoop = false;
        this.observer = observer;
        tick(0);
    }

    public function stop() {
        this.shouldExitLoop = true;
        this.observer = null;
    }
}
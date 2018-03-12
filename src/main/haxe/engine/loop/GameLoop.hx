package engine.loop;

import js.Browser;
import engine.loop.GameLoopObserver;

class GameLoop {
    private var shouldExitLoop: Bool;
    private var observers: Array<GameLoopObserver>;

    public function new() {
        this.observers = new Array<GameLoopObserver>();
    }

    public function subscribe(observer: GameLoopObserver) {
        this.observers.push(observer);
    }

    public function unsubscribe(observer: GameLoopObserver) {
        this.observers.remove(observer);
    }

    private function tick(timestamp: Float) {
        if(shouldExitLoop)
            return;

        Browser.window.requestAnimationFrame(tick);

        for(observer in this.observers)
            observer.update(timestamp);
    }

    public function start() {
        this.shouldExitLoop = false;
        tick(0);
    }

    public function stop() {
        this.shouldExitLoop = true;
    }
}
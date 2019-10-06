package engine.input;

import js.Browser;
import js.html.KeyboardEvent;
import engine.input.Key;
import lang.Debug;

class Keyboard {
    private var trackedKeys: Map<Int, Key>;

    public function new (keys: Array<Key>) {
        Browser.window.addEventListener("keydown", onKeyDown);
        Browser.window.addEventListener("keyup", onKeyUp);
        this.trackedKeys = new Map<Int, Key>();
        for(key in keys) {
            Debug.assert(this.trackedKeys[key.code] == null, "Tracked keys cannot repeat in keyboard."); 
            this.trackedKeys[key.code] = key;
        }
    }

    private function onKeyDown(event: KeyboardEvent) {
        trace('Key down ${event.keyCode}');
        var key = trackedKeys[event.keyCode];

        //key is not being tracked
        if(key == null)
            return;
        
        key.nextState = Key.KEY_DOWN;
    }

    private function onKeyUp(event: KeyboardEvent) {
        var key = trackedKeys[event.keyCode];

        //key is not being tracked
        if(key == null)
            return;

        key.nextState = Key.KEY_UP;
    }

    public function update() {
        for (code in this.trackedKeys.keys()) {
            this.trackedKeys[code].previousState = this.trackedKeys[code].currentState;
            this.trackedKeys[code].currentState = this.trackedKeys[code].nextState;
        }
    }

    public function dispose() {
        Browser.window.removeEventListener("keydown", onKeyDown);
        Browser.window.removeEventListener("keyup", onKeyUp);
    }
}
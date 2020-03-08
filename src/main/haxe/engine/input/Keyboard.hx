package engine.input;

import js.Browser;
import js.html.KeyboardEvent;
import engine.input.Key;
import lang.Debug;

class Keyboard {
    private var trackedKeys:Map<Int, Key>;
    private var trackedKeyCodes:Array<Int>;

    public function new (keys:Array<Key>) {
        Browser.window.addEventListener("keydown", onKeyDown);
        Browser.window.addEventListener("keyup", onKeyUp);
        this.trackedKeys = new Map<Int, Key>();
        this.trackedKeyCodes = new Array<Int>();
        for(key in keys) {
            Debug.assert(this.trackedKeys[key.code] == null, "Tracked keys cannot repeat in keyboard."); 
            this.trackedKeys[key.code] = key;
            this.trackedKeyCodes.push(key.code);
        }
    }

    private function onKeyDown(event:KeyboardEvent) {
        var key = trackedKeys[event.keyCode];

        //key is not being tracked
        if(key == null)
            return;
        
        key.nextState = Key.KEY_DOWN;
    }

    private function onKeyUp(event:KeyboardEvent) {
        var key = trackedKeys[event.keyCode];

        //key is not being tracked
        if(key == null)
            return;

        key.nextState = Key.KEY_UP;
    }

    public function update() {
        for (code in this.trackedKeyCodes) {
            this.trackedKeys[code].previousState = this.trackedKeys[code].currentState;
            this.trackedKeys[code].currentState = this.trackedKeys[code].nextState;
        }
    }

    public function dispose() {
        Browser.window.removeEventListener("keydown", onKeyDown);
        Browser.window.removeEventListener("keyup", onKeyUp);
        for (code in this.trackedKeyCodes) {
            this.trackedKeys[code].previousState = Key.KEY_UP;
            this.trackedKeys[code].currentState = Key.KEY_UP;
            this.trackedKeys[code].nextState = Key.KEY_UP;
        }
    }
}
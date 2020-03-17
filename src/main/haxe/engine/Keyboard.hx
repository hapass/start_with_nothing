package engine;

import js.Browser;
import js.html.KeyboardEvent;

class Key {
    public static var KEY_DOWN = "KEY_DOWN";
    public static var KEY_UP = "KEY_UP";

    public static var SPACE:Key = new Key(32);
    public static var RIGHT:Key = new Key(39);
    public static var LEFT:Key = new Key(37);
    public static var SHIFT:Key = new Key(16);

    public var code:Int = 0;

    public var nextState:String = KEY_UP;
    public var currentState:String = KEY_UP;
    public var previousState:String = KEY_UP;

    public function wasPressed() {
        return 
            this.currentState == Key.KEY_DOWN && 
            this.previousState == Key.KEY_UP;
    }

    public function isPressed() {
        return this.currentState == Key.KEY_DOWN;
    }

    private function new(code:Int) {
        this.code = code;
    }
}

class Keyboard {
    private var trackedKeys:Map<Int, Key> = new Map<Int, Key>();
    private var trackedKeyCodes:Array<Int> = new Array<Int>();

    public function new (keys:Array<Key>) {
        Browser.window.addEventListener("keydown", onKeyDown);
        Browser.window.addEventListener("keyup", onKeyUp);
        for (key in keys) {
            Debug.assert(this.trackedKeys[key.code] == null, "Tracked keys cannot repeat in keyboard."); 
            this.trackedKeys[key.code] = key;
            this.trackedKeyCodes.push(key.code);
        }
    }

    private function onKeyDown(event:KeyboardEvent) {
        var key = trackedKeys[event.keyCode];

        if (key == null) {
            Debug.log('Key is not tracked: ${key.code}');
            return;
        }
        
        key.nextState = Key.KEY_DOWN;
    }

    private function onKeyUp(event:KeyboardEvent) {
        var key = trackedKeys[event.keyCode];

        if (key == null) {
            Debug.log('Key is not tracked: ${key.code}');
            return;
        }

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
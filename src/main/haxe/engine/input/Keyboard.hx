package engine.input;

import js.Browser;
import js.html.KeyboardEvent;
import engine.input.Key;
import lang.Debug;

class Keyboard {
    private static inline var KEY_DOWN = "KEY_DOWN";
    private static inline var KEY_UP = "KEY_UP";
    private static inline var KEY_PRESSED = "KEY_PRESSED";

    private var trackedKeys: Array<Key>;
    private var observers: Array<KeyboardObserver>;    

    public function new (trackedKeys: Array<Key>) {
        Browser.window.addEventListener("keydown", onKeyDown);
        Browser.window.addEventListener("keyup", onKeyUp);
        this.trackedKeys = new Array<Key>();
        this.observers = new Array<KeyboardObserver>();
        for(key in trackedKeys) {
            Debug.assert(this.trackedKeys[key.code] == null, "Tracked keys cannot repeat in keyboard."); 
            key.setState(KEY_UP);      
            this.trackedKeys[key.code] = key;
        }
    }

    private function onKeyDown(event: KeyboardEvent) {
        var key = trackedKeys[event.keyCode];

        //key is not being tracked
        if(key == null)
            return;
        
        key.setState(KEY_DOWN);
    }

    private function onKeyUp(event: KeyboardEvent) {
        var key = trackedKeys[event.keyCode];

        //key is not being tracked
        if(key == null)
            return;
        
        key.setState(KEY_UP);
    }

    public function subscribe(observer: KeyboardObserver) {
        this.observers.push(observer);
    }

    public function unsubscribe(observer: KeyboardObserver) {
        this.observers.remove(observer);
    }

    public function checkInput() {
        for(observer in this.observers)
            observer.onInput({
                isKeyDown: this.isKeyDown,
                hasBeenPressed: this.hasBeenPressed
            });
    }

    private function isKeyDown(key: Key) {
        return key.currentState == KEY_DOWN;
    }

    private function hasBeenPressed(key: Key) {
        var pressed = key.currentState == KEY_DOWN && key.previousState == KEY_UP;
        if(pressed)
            key.setState(KEY_PRESSED);
        return pressed;
    }

    public function dispose() {
        Browser.window.removeEventListener("keydown", onKeyDown);
        Browser.window.removeEventListener("keyup", onKeyUp);
    }
}
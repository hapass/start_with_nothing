package engine.input;

import js.Browser;

class Keyboard {

    public function new () {
        Browser.window.addEventListener("keydown", onKeyDown);
    }

    private function onKeyDown(event) {

    }

    public function isKeyDownkey(key: Key) {

    }

}
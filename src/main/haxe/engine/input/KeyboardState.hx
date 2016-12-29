package engine.input;

typedef KeyboardState = {
    function isKeyDown(key: Key): Bool;
    function hasBeenPressed(key: Key): Bool;
}
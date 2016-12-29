package engine.input;

@:allow(engine.input.Keyboard)
class Key {
    public static var SPACE(get, never): Key;

    private static var spaceKey: Key;
    private static inline function get_SPACE(): Key {
        if(spaceKey == null)
            spaceKey = new Key(32);
        return spaceKey;
    }
        
    private var code: Int;
    private var currentState: String;
    private var previousState: String;

    private function new(code: Int) {
        this.code = code;
    }

    private function setState(state: String) {
        this.previousState = currentState;
        this.currentState = state;
    }
}
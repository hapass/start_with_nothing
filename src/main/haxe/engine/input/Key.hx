package engine.input;

class Key {
    public static inline var KEY_DOWN = "KEY_DOWN";
    public static inline var KEY_UP = "KEY_UP";

    public static var SPACE(get, never): Key;

    private static var spaceKey: Key;
    private static inline function get_SPACE(): Key {
        if(spaceKey == null)
            spaceKey = new Key(32);
        return spaceKey;
    }
        
    public var code: Int;

    public var nextState: String;
    public var currentState: String;
    public var previousState: String;

    private function new(code: Int) {
        this.code = code;
        this.currentState = KEY_UP;
        this.previousState = KEY_UP;
        this.nextState = KEY_UP;
    }
}
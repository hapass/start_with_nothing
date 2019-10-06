package engine.input;

class Key {
    public static inline var KEY_DOWN = "KEY_DOWN";
    public static inline var KEY_UP = "KEY_UP";

    private static var spaceKey: Key;
    public static var SPACE(get, never): Key;
    private static inline function get_SPACE(): Key {
        if(spaceKey == null)
            spaceKey = new Key(32);
        return spaceKey;
    }

    private static var rightKey: Key;
    public static var RIGHT(get, never): Key;
    private static inline function get_RIGHT(): Key {
        if(rightKey == null)
            rightKey = new Key(39);
        return rightKey;
    }

    private static var leftKey: Key;
    public static var LEFT(get, never): Key;
    private static inline function get_LEFT(): Key {
        if(leftKey == null)
            leftKey = new Key(37);
        return leftKey;
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
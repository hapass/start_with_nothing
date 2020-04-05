package engine;

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
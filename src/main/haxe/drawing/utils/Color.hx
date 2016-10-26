package drawing.utils;

class Color {
    public var r(default, set): Int;
    public var g(default, set): Int;
    public var b(default, set): Int;
    public var a(default, set): Int;

    public function set_r(value: Int): Int {
        throwIfOutOfBounds(value);
        return r = value;
    }

    public function set_g(value: Int): Int {
        throwIfOutOfBounds(value);
        return g = value;
    }

    public function set_b(value: Int): Int {
        throwIfOutOfBounds(value);
        return b = value;
    }

    public function set_a(value: Int): Int {
        throwIfOutOfBounds(value);
        return a = value;
    }

    private function throwIfOutOfBounds(value: Int) {
        if(value < 0 || value > 255)
            throw "Color value is out of bounds. Should be from 0 to 255.";
    }

    public static var RED(get, never): Color;
    static function get_RED(): Color return new Color(255, 0, 0, 255);

    public static var GREEN(get, never): Color;
    static function get_GREEN(): Color return new Color(0, 255, 0, 255);

    public static var BLUE(get, never): Color;
    static function get_BLUE(): Color return new Color(0, 0, 255, 255);

    public function new(r: Int, g: Int, b: Int, a: Int) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }
}
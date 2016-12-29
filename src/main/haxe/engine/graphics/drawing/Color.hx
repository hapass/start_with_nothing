package engine.graphics.drawing;

import lang.Debug;

class Color {
    public var r(default, null): Int;
    public var g(default, null): Int;
    public var b(default, null): Int;

    public static var RED(get, never): Color;
    static function get_RED(): Color return new Color(255, 0, 0);

    public static var GREEN(get, never): Color;
    static function get_GREEN(): Color return new Color(0, 255, 0);

    public static var BLUE(get, never): Color;
    static function get_BLUE(): Color return new Color(0, 0, 255);

    public static var YELLOW(get, never): Color;
    static function get_YELLOW(): Color return new Color(255, 255, 0);

    public static var WHITE(get, never): Color;
    static function get_WHITE(): Color return new Color(255, 255, 255);

    public static var BLACK(get, never): Color;
    static function get_BLACK(): Color return new Color(0, 0, 0);

    public function new(r: Int, g: Int, b: Int) {
        this.r = correctColor(r);
        this.g = correctColor(g);
        this.b = correctColor(b);
    }

    private function correctColor(value: Int) {
        Debug.assert(value >= 0 && value <= 255, "Each color value should be between 0 and 255.");

        if(value < 0)
            return 0;
        
        if(value > 255)
            return 255;

        return value;
    }
}
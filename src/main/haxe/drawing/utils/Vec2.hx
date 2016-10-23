package drawing.utils;

class Vec2 {
    public static inline var DIMENSIONS_NUMBER = 2;

    public var x: Float;
    public var y: Float;

    public function new (x: Float, y: Float) {
        this.x = x;
        this.y = y;
    }

    public function add(vec: Vec2): Vec2 {
        return new Vec2(vec.x + this.x, vec.y + this.y);
    }
}
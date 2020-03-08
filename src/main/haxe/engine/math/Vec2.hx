package engine.math;

class Vec2 {
    public var x(default, null): Float;
    public var y(default, null): Float;

    public function new(x: Float, y: Float) {
        this.x = x;
        this.y = y;
    }

    public function add(vec: Vec2):Void {
        this.x += vec.x;
        this.y += vec.y;
    }

    public function subtract(vec:Vec2):Void {
        this.x -= vec.x;
        this.y -= vec.y;
    }
}
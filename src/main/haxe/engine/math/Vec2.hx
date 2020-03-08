package engine.math;

class Vec2 {
    public var x:Float;
    public var y:Float;

    public function new() {
        this.x = 0;
        this.y = 0;
    }

    public function add(x:Float, y:Float):Void {
        this.x += x;
        this.y += y;
    }

    public function set(x:Float, y:Float):Void {
        this.x = x;
        this.y = y;
    }
}
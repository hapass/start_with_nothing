package engine.math;

class Vec2 {
    public var x:Float;
    public var y:Float;

    public function new(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }

    public function add(vec:Vec2):Void {
        this.x += vec.x;
        this.y += vec.y;
    }

    public function addFloat(x:Float, y:Float):Void {
        this.x += x;
        this.y += y;
    }

    public function subtract(vec:Vec2):Void {
        this.x -= vec.x;
        this.y -= vec.y;
    }

    public function set(x:Float, y:Float):Void {
        this.x = x;
        this.y = y;
    }
}
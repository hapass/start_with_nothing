package engine;

class Vec2 {
    public var x:Float = 0.0;
    public var y:Float = 0.0;

    public function new() {}

    public function add(x:Float, y:Float):Void {
        this.x += x;
        this.y += y;
    }

    public function set(x:Float, y:Float):Void {
        this.x = x;
        this.y = y;
    }
}
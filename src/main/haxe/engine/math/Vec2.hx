package engine.math;

@:generic
class Vec2<T> {
    public var x:Dynamic = 0;
    public var y:Dynamic = 0;

    public function new() {}

    public function add(x:T, y:T):Void {
        this.x += x;
        this.y += y;
    }

    public function set(x:T, y:T):Void {
        this.x = x;
        this.y = y;
    }
}
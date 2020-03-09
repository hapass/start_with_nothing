package engine.math;

import js.html.TableCaptionElement;

@:generic
class Vec2<T> {
    public var x:T;
    public var y:T;

    @:abstract
    public function add(x:T, y:T){}

    public function set(x:T, y:T):Void {
        this.x = x;
        this.y = y;
    }
}

class Vec2Float extends Vec2<Float> {
    public function new() {}
    override public function add(x:Float, y:Float):Void {
        this.x += x;
        this.y += y;
    }
}

class Vec2Int extends Vec2<Int> {
    public function new() {}
    override public function add(x:Int, y:Int):Void {
        this.x += x;
        this.y += y;
    }
}
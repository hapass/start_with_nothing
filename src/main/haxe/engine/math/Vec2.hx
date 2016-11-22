package engine.math;

class Vec2 {
    public var x(default, null): Float;
    public var y(default, null): Float;

    public function new(x: Float, y: Float) {
        this.x = x;
        this.y = y;
    }

    public function add(vec: Vec2): Vec2 {
        return new Vec2(vec.x + this.x, vec.y + this.y);
    }

    public function subtract(vec: Vec2) {
        return new Vec2(this.x - vec.x, this.y - vec.y);
    }

    public function copy(): Vec2 {
        return new Vec2(this.x, this.y);
    }

    public function toArray(): Array<Float> {
        return [
            this.x,
            this.y
        ];
    }
}
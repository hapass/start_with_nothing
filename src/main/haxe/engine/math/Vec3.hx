package engine.math;

class Vec3 {
    public var x(default, null): Float;
    public var y(default, null): Float;
    public var z(default, null): Float;

    public function new(x: Float, y: Float, z: Float) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function add(vec: Vec3): Vec3 {
        return new Vec3(vec.x + this.x, vec.y + this.y, vec.z + this.z);
    }

    public function subtract(vec: Vec3) {
        return new Vec3(this.x - vec.x, this.y - vec.y, this.z - vec.z);
    }

    public function copy(): Vec3 {
        return new Vec3(this.x, this.y, this.z);
    }

    public function toArray(): Array<Float> {
        return [
            this.x,
            this.y,
            this.z
        ];
    }

    public function iterator():Iterator<Float> {
        return this.toArray().iterator();
    }
}
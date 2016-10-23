package drawing.utils;

class Color {
    public var r(default, set): Int;
    public var g(default, set): Int;
    public var b(default, set): Int;
    public var a(default, set): Int;

    public function set_r(value: Int): Int {
        throwIfOutOfBounds(value);
        return r = value;
    }

    public function set_g(value: Int): Int {
        throwIfOutOfBounds(value);
        return r = value;
    }

    public function set_b(value: Int): Int {
        throwIfOutOfBounds(value);
        return r = value;
    }

    public function set_a(value: Int): Int {
        throwIfOutOfBounds(value);
        return r = value;
    }

    private function throwIfOutOfBounds(value: Int) {
        if(value < 0 || value > 255)
            throw "Color value is out of bounds. Should be from 0 to 255.";
    }

    public function new(r: Int, g: Int, b: Int, a: Int) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }
}
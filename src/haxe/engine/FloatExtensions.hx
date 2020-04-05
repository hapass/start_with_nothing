package engine;

class FloatExtensions {
    static public function equals(first:Float, second:Float) {
        return Math.abs(first - second) < 0.00001;
    }
}
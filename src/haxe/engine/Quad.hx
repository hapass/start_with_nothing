package engine;

class Quad {
    public var color:Color;
    public var size:Float;
    public var position:Vec2;

    public function new(
        color:Color,
        size:Float,
        position:Vec2
    ) {
        this.color = color;
        this.size = size;
        this.position = position;
    }
}
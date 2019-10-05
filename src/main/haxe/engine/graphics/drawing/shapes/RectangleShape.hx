package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;

class RectangleShape implements Shape {
    public var color(default, null):Color;
    public var height(default, null):Float;
    public var width(default, null):Float;
    public var position(default, null):Vec2;

    public var isVisible(get, never):Bool;
    private function get_isVisible():Bool return true;

    public function new(coords:Vec2, width:Float, height:Float) {
        this.position = coords;
        this.height = height;
        this.width = width;
        this.color = Color.WHITE;
    }

    public function setColor(color:Color):Shape {
        this.color = color;
        return this;
    }

    public function move(vec:Vec2) {
        this.position = this.position.add(vec);
    }
}
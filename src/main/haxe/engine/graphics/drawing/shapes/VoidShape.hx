package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;

class VoidShape implements Shape {
    public var position(get, null):Vec2;

    public var color(default, null): Color;
    public var texture(default, null): Texture;
    public var text(default, null): String;
    public var height(default, null): Float;

    public function new() { 
        this.position = new Vec2(0, 0);
    }

    public function move(vec: Vec2) {
        //nothing to move
    }

    public function getVertices(): Array<Vec2> {
        return [];
    }

    private function get_position(): Vec2 {
        return this.position;
    }
}
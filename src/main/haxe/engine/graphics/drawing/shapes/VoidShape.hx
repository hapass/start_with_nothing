package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;

class VoidShape implements Shape {
    public var color(default, null): Color;
    public var texture(default, null): Texture;

    public function new() { 
        //do nothing
    }

    public function move(vec: Vec2) {
        //nothing to move
    }

    public function getVertices(): Array<Vec2> {
        return [];
    }
}
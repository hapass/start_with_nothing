package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;

interface Shape {
    public function move(vec: Vec2): Void;
    public function getVertices(): Array<Vec2>;
    public var color(default, null): Color;
    public var texture(default, null): Texture;
}
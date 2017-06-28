package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;

interface Shape {
    public function move(vec: Vec2): Void;
    public function getVertices(): Array<Vec2>;

    public var position(get, never): Vec2;

    public var height(default, null): Float;
    public var color(default, null): Color;
    public var texture(default, null): Texture;
    public var text(default, null): String;
}
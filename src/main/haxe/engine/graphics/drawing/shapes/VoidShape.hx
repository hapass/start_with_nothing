package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;
import engine.graphics.rendering.Texture;
import lang.Promise;

class VoidShape implements Shape {
    public var position(default, null):Vec2;
    public var texture(default, null):Texture;
    public var height(default, null):Float;
    public var width(default, null):Float;

    public var isVisible(get, never):Bool;
    private function get_isVisible():Bool return false;

    public function new() { }

    public function move(vec:Vec2) {}
    public function setColor(color:Color):Shape return this;
}
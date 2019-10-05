package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;

interface Shape {
    function move(vec:Vec2):Void;
    function setColor(color:Color):Shape;

    var position(default, null):Vec2;
    var height(default, null):Float;
    var width(default, null):Float;
    var color(default, null):Color;
    var isVisible(get, never):Bool;
}
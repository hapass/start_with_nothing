package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;
import engine.graphics.rendering.Texture;
import lang.Promise;

interface Shape {
    function move(vec:Vec2):Void;
    
    function setImageUrl(url:String):Promise<Shape>;
    function setColor(color:Color):Shape;

    var position(default, null):Vec2;
    var height(default, null):Float;
    var width(default, null):Float;

    var texture(default, null):Texture;

    var isVisible(get, never):Bool;
}
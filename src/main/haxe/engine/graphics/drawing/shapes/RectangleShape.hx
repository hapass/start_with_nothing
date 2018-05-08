package engine.graphics.drawing.shapes;

import engine.math.Vec2;
import engine.graphics.drawing.Color;
import engine.graphics.rendering.Texture;
import lang.Debug;
import lang.Promise;

class RectangleShape implements Shape {
    public var texture(default, null):Texture;
    public var height(default, null):Float;
    public var width(default, null):Float;
    public var position(default, null):Vec2;

    public var isVisible(get, never):Bool;
    private function get_isVisible():Bool return true;

    private static var colorTexturesCache:Map<Color, Texture> = new Map<Color, Texture>();
    private static var urlTextureCache:Map<String, Texture> = new Map<String, Texture>();

    public function new(coords:Vec2, width:Float, height:Float) {
        this.position = coords;

        this.height = height;
        this.width = width;
    }

    public function setColor(color:Color):Shape {
        Debug.assert(this.texture == null, "Texture is already set for a shape.");

        if(RectangleShape.colorTexturesCache.exists(color)) {
            this.texture = RectangleShape.colorTexturesCache.get(color);
        } else {
            this.texture = Texture.fromColor(color.r, color.g, color.b);
            RectangleShape.colorTexturesCache.set(color, this.texture);
        }

        return this;
    }

    public function setImageUrl(url:String):Promise<Shape> {
        Debug.assert(this.texture == null, "Texture is already set for a shape.");
        var promise = new Promise<Shape>();

        if(RectangleShape.urlTextureCache.exists(url)) {
            this.texture = RectangleShape.urlTextureCache.get(url);
            promise.resolve(this);
        } else {
            Texture.fromUrl(url).then(function(urlTexture:Texture) {
                this.texture = urlTexture;
                promise.resolve(this);
            });
        }

        return promise;
    }

    public function move(vec:Vec2) {
        this.position = this.position.add(vec);
    }
}
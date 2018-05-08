package engine.graphics.rendering;

import js.html.Uint8Array;
import lang.Promise;
import js.html.Image;

class Texture {
    public var data(default, null):TextureData;

    private function new() {}

    public static function fromUrl(url:String):Promise<Texture> {
        var image:Image = new Image();

        var texture:Texture = new Texture();
        texture.data = TextureData.ImageElement(image);

        var promise:Promise<Texture> = new Promise<Texture>();
        image.onload = function() {
            promise.resolve(texture);
        };
        image.src = url;

        return promise;
    }

    public static function fromColor(red:Int, green:Int, blue:Int):Texture {
        var texture = new Texture();
        texture.data = TextureData.ColorArray(new Uint8Array([
            red, green, blue, 255,
            red, green, blue, 255,
            red, green, blue, 255,
            red, green, blue, 255,
        ]));
        return texture;
    }
}
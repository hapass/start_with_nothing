package engine.graphics.rendering;

import lang.Promise;
import js.html.Uint8ClampedArray;
import js.html.Image;

class Texture {
    public var data(default, null):TextureData;

    private function new() {}

    public static function fromUrl(url:String):Promise<Texture> {
        var image:Image = new Image();

        var texture:Texture = new Texture();
        texture.data = TextureData.ImageElement(image);

        var promise:Promise<Texture> = new Promise<Texture>();
        image.onload = promise.resolve.bind(texture);
        image.src = url;

        return promise;
    }

    public static function fromColor(red:Int, green:Int, blue:Int):Texture {
        var texture = new Texture();
        texture.data = TextureData.ColorArray(Uint8ClampedArray.from([red, green, blue, 1]));
        return texture;
    }
}
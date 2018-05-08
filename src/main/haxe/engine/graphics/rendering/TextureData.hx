package engine.graphics.rendering;

import js.html.Uint8Array;
import js.html.Image;

enum TextureData {
    ColorArray(array:Uint8Array);
    ImageElement(element:Image);
}
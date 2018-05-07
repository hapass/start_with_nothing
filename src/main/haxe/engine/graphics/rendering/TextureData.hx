package engine.graphics.rendering;

import js.html.Image;

enum TextureData {
    ColorArray(array:Uint8ClampedArray);
    ImageElement(element:Image);
}
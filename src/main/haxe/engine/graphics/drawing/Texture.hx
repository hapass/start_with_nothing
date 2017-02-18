package engine.graphics.drawing;

//should be bytes
import js.html.Image;

class Texture {
    @:allow(engine.graphics.drawing.DrawingBoard)    
    private var data: Image;

    public function new() {}

    public function load(url: String, loaded: Void -> Void) {
        var image: Image = new Image();
        image.onload = function() {
            this.data = image;
            loaded();
        };
        image.src = url;
    }
}
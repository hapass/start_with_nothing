package engine.graphics.drawing;

//should be bytes
import js.html.Image;

class Texture {
    @:allow(engine.graphics.drawing.DrawingBoard)    
    private var data: Image;

    public function new() {
        this.data = new Image();
    }

    public function load(url: String, loaded: Void -> Void) {
        this.data.onload = loaded;        
        this.data.src = url;
    }
}
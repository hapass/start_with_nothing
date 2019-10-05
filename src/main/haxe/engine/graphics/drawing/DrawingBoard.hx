package engine.graphics.drawing;

import engine.graphics.drawing.shapes.Shape;
import engine.graphics.rendering.Renderer;

class DrawingBoard {
    private var renderer:Renderer;
    private var shapes:Array<Shape>;

    public function new(width:Int, height:Int) {
        this.renderer = new Renderer(width, height);
        this.shapes = new Array<Shape>();
    }

    public function add(shape:Shape) {
        this.shapes.push(shape);
    }

    public function remove(shape:Shape) {
        this.shapes.remove(shape);
    }

    public function draw() {
        renderer.clear();
        for(shape in shapes) {
            if(shape.isVisible) {
                renderer.drawQuad(shape.position, Std.int(shape.width), Std.int(shape.height), shape.color.toVec3());
            }
        }
    }

    public function dispose() {
        this.renderer.dispose();
    }
}
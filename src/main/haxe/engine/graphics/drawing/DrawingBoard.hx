package engine.graphics.drawing;

import engine.graphics.drawing.shapes.Rectangle;
import engine.graphics.rendering.Renderer;
import engine.math.Vec3;

class DrawingBoard {
    private var renderer: Renderer;
    private var shapes: Array<Rectangle>;

    public function new(width: Int, height: Int) {
        this.shapes = new Array<Rectangle>();
        this.renderer = new Renderer(width, height);
    }

    public function add(shape: Rectangle) {
        this.shapes.push(shape);
    }

    public function draw() {
        renderer.clear();
        for(shape in shapes)
            renderer.drawTriangleStrip(shape.getVertices(), new Vec3(shape.color.r, shape.color.g, shape.color.b));
    }
}
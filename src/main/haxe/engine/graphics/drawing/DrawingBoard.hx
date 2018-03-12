package engine.graphics.drawing;

import engine.graphics.drawing.shapes.Shape;
import engine.graphics.rendering.Renderer;
import engine.math.Vec3;

class DrawingBoard {
    private var renderer: Renderer;
    private var shapes: Array<Shape>;

    public function new(width: Int, height: Int) {
        this.shapes = new Array<Shape>();
        this.renderer = new Renderer(width, height);
    }

    public function add(shape: Shape) {
        this.shapes.push(shape);
    }

    public function remove(shape: Shape) {
        this.shapes.remove(shape);
    }

    public function draw() {
        renderer.clear();
        for(shape in shapes) {
            var vertices = shape.getVertices();
            if(vertices != null && vertices.length > 0) {
                if(shape.color != null) {
                    var vecColor: Vec3 = new Vec3(shape.color.r, shape.color.g, shape.color.b);
                    if(shape.text != null) {
                        renderer.drawText(shape.text, shape.position, vecColor, Std.int(shape.height));
                    } else {
                        renderer.drawTriangleStrip(vertices, vecColor);
                    }
                } else if (shape.texture != null) {
                    renderer.drawTriangleStripTexture(vertices, shape.texture.data);
                }
            }
        }
    }

    public function dispose() {
        this.renderer.dispose();
    }
}
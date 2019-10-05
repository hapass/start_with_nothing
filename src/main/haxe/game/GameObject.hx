package game;

import engine.graphics.drawing.shapes.VoidShape;
import engine.graphics.drawing.shapes.Shape;
import engine.input.VoidKeyboardObserver;
import engine.input.KeyboardObserver;

class GameObject {
    public var disposed(default, null):Bool;

    public function new() {
        this.disposed = false;
    }

    public function update(timestamp: Float) {
        //no default behavior
    }

    public function getShape(): Array<Shape> {
        var compositeShape = new Array<Shape>();
        compositeShape.push(new VoidShape());
        return compositeShape;
    }

    public function getKeyboardObserver(): KeyboardObserver {
        return new VoidKeyboardObserver();
    }
}
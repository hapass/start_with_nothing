package game;

import engine.graphics.drawing.shapes.VoidShape;
import engine.graphics.drawing.shapes.Shape;
import engine.input.VoidKeyboardObserver;
import engine.input.KeyboardObserver;

class GameObject {
    public function update(timestamp: Float) {
        throw "Game object's update method must be overriden.";
    }

    public function getShape(): Shape {
        return new VoidShape();
    }

    public function getKeyboardObserver(): KeyboardObserver {
        return new VoidKeyboardObserver();
    }
}
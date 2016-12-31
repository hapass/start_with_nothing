package game;

import engine.graphics.drawing.shapes.VoidShape;
import engine.graphics.drawing.shapes.Shape;
import engine.input.VoidKeyboardObserver;
import engine.input.KeyboardObserver;
import engine.collisions.Collider;

class GameObject {
    private static inline var DEFAULT_COLLISION_GROUP_NAME: String = "Default";

    public var disposed(default, null): Bool;
    public var notifyAboutCollisions(default, null): Bool;

    public function new() {
        this.disposed = false;
        this.notifyAboutCollisions = false;
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

    public function getCollider(): Array<Collider> {
        return null;
    }

    public function getCollisionGroupName(): String {
        return DEFAULT_COLLISION_GROUP_NAME;
    }
}
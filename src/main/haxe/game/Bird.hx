package game;

import engine.math.Vec2;
import engine.math.Vec3;

import engine.graphics.drawing.Color;
import engine.graphics.drawing.shapes.Rectangle;

import engine.input.KeyboardState;
import engine.input.Key;
import engine.input.KeyboardObserver;

class Bird extends GameObject implements KeyboardObserver {
    private var shape: Rectangle;

    public function new() {
        this.shape = new Rectangle(new Vec2(0, 0), 10, 10, Color.YELLOW);
    }

    override public function update(timestamp: Float) {
        //apply gravity
    }

    override public function getKeyboardObserver() {
        return this;
    }

    override public function getShape() {
        return this.shape;
    }

    public function onInput(state: KeyboardState) {
        if(state.isKeyDown(Key.SPACE))
            this.shape.move(new Vec2(1, 0));
        
        if(state.hasBeenPressed(Key.SPACE))
            this.shape.move(new Vec2(200, 0));
    }

    function applyGravity(): Float {
        /*
            Draws bird down to earth.
            Take bird. Move on a vector down to earth.
        */
        return 0;
    }
}
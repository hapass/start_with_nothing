package game;

import engine.math.Vec2;
import engine.math.Vec3;

import engine.graphics.drawing.Color;
import engine.graphics.drawing.shapes.RectangleShape;
import engine.graphics.drawing.shapes.Shape;

import engine.input.KeyboardState;
import engine.input.Key;
import engine.input.KeyboardObserver;

import engine.collisions.Collider;

class Bird extends GameObject implements KeyboardObserver {
    private var shape: RectangleShape;
    private var collider: Collider;
    private var currentSpeed: Vec2;
    private var acceleration: Vec2;

    public function new() {
        super();
        var position = new Vec2(50, 50);
        this.shape = new RectangleShape(position, 10, 10, Color.YELLOW);
        this.collider = new Collider(position, 10, 10);
        this.currentSpeed = new Vec2(0, 0);
        this.acceleration = new Vec2(0, 0.1);
        this.notifyAboutCollisions = true;
    }

    override public function update(timestamp: Float) {
        applyGravity();
        move();
    }

    override public function getKeyboardObserver() {
        return this;
    }

    override public function getCollider(): Array<Collider> {
        return [this.collider];
    }

    override public function getShape(): Array<Shape> {
        var array:Array<Shape> = new Array<Shape>();
        array.push(this.shape);
        return array;
    }

    override public function getCollisionGroupName(): String {
        return "Bird";
    }

    public function onInput(state: KeyboardState): Void {
        if(state.hasBeenPressed(Key.SPACE))
            fly();
    }

    private function fly() {
        this.currentSpeed = new Vec2(0, -2);
    }

    private function applyGravity() {
        this.currentSpeed = this.currentSpeed.add(this.acceleration);
    }

    private function move() {
        this.shape.move(this.currentSpeed);
        this.collider.move(this.currentSpeed);
    }
}
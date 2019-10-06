package game;

import engine.math.Vec2;

import engine.graphics.drawing.shapes.RectangleShape;
import engine.graphics.drawing.shapes.Shape;
import engine.graphics.drawing.Color;

class Glow {
    public var shape:Shape;
    public var currentSpeed:Vec2;
    public var acceleration:Vec2;
    public var position:Vec2;

    public function new() {
        this.currentSpeed = new Vec2(0, 0);
        this.acceleration = new Vec2(0, Config.GLOW_FALL_ACCELERATION);
        this.position = new Vec2(Config.GLOW_LEFT_DISTANCE, Config.GLOW_UP_DISTANCE);
        this.shape = new RectangleShape(this.position, Config.GLOW_WIDTH, Config.GLOW_HEIGHT).setColor(Color.BLUE);
    }
}
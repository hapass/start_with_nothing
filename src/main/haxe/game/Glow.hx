package game;

import engine.math.Vec2;
import engine.graphics.Renderer;

class Glow {
    public var shape:Quad;
    public var currentSpeed:Vec2;
    public var acceleration:Vec2;
    public var position:Vec2;

    public var topLeftCorner:Vec2;
    public var topRightCorner:Vec2;
    public var bottomLeftCorner:Vec2;
    public var bottomRightCorner:Vec2;
    public var center:Vec2;

    public var isTopIntersecting:Bool;
    public var isBottomIntersecting:Bool;
    public var isLeftIntersecting:Bool;
    public var isRightIntersecting:Bool;

    public function new(pos:Vec2) {
        this.currentSpeed = new Vec2(0, 0);
        this.topLeftCorner = new Vec2(0, 0);
        this.topRightCorner = new Vec2(0, 0);
        this.bottomLeftCorner = new Vec2(0, 0);
        this.bottomRightCorner = new Vec2(0, 0);
        this.center = new Vec2(0, 0);
        this.acceleration = new Vec2(0, Config.GLOW_FALL_ACCELERATION);
        this.position = pos;
        this.shape = new Quad();
        this.shape.position = this.position;
        this.shape.width = Config.GLOW_WIDTH;
        this.shape.height = Config.GLOW_HEIGHT;
        this.shape.color = Config.GLOW_COLOR;
    }

    public function move(offset:Vec2) {
        this.position.add(offset);
        this.shape.position = this.position;
        this.topLeftCorner.set(this.position.x, this.position.y);
        this.topRightCorner.set(this.position.x + Config.GLOW_WIDTH - 1, this.position.y);
        this.bottomLeftCorner.set(this.position.x, this.position.y + Config.GLOW_HEIGHT);
        this.bottomRightCorner.set(this.position.x + Config.GLOW_WIDTH - 1, this.position.y + Config.GLOW_HEIGHT);
        this.center.set(this.position.x + Std.int(Config.GLOW_WIDTH / 2), this.position.y + Std.int(Config.GLOW_HEIGHT / 2));
    }
}
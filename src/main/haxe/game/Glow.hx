package game;

import engine.math.Vec2;
import engine.graphics.Renderer;

class Glow {
    public var shape:Quad;
    public var currentSpeed:Vec2;
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
    public var isYellowSquareIntersecting:Bool;

    public function new(pos:Vec2) {
        this.currentSpeed = new Vec2();
        this.topLeftCorner = new Vec2();
        this.topRightCorner = new Vec2();
        this.bottomLeftCorner = new Vec2();
        this.bottomRightCorner = new Vec2();
        this.center = new Vec2();
        this.position = new Vec2();
        this.shape = new Quad();
        this.shape.width = Config.GLOW_WIDTH;
        this.shape.height = Config.GLOW_HEIGHT;
        this.shape.color = Config.GLOW_COLOR;
        setPosition(pos.x, pos.y);
    }

    public function move() {
        setPosition(this.position.x + this.currentSpeed.x, this.position.y + this.currentSpeed.y);
    }

    public function setPosition(x:Float, y:Float) {
        this.position.set(x, y);
        this.shape.position = this.position;
        this.topLeftCorner.set(this.position.x, this.position.y);
        this.topRightCorner.set(this.position.x + Config.GLOW_WIDTH - 1, this.position.y);
        this.bottomLeftCorner.set(this.position.x, this.position.y + Config.GLOW_HEIGHT);
        this.bottomRightCorner.set(this.position.x + Config.GLOW_WIDTH - 1, this.position.y + Config.GLOW_HEIGHT);
        this.center.set(this.position.x + Std.int(Config.GLOW_WIDTH / 2), this.position.y + Std.int(Config.GLOW_HEIGHT / 2));
    }
}
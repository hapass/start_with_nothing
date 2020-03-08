package game;

import engine.math.Vec2;
import engine.graphics.Renderer;

class Glow {
    public var shape:Quad = new Quad();
    public var currentSpeed:Vec2 = new Vec2();
    public var position:Vec2 = new Vec2();

    public var topLeftCorner:Vec2 = new Vec2();
    public var topRightCorner:Vec2 = new Vec2();
    public var bottomLeftCorner:Vec2 = new Vec2();
    public var bottomRightCorner:Vec2 = new Vec2();
    public var center:Vec2 = new Vec2();

    public var isTopIntersecting:Bool = false;
    public var isBottomIntersecting:Bool = false;
    public var isLeftIntersecting:Bool = false;
    public var isRightIntersecting:Bool = false;
    public var isYellowSquareIntersecting:Bool = false;

    public function new() {
        this.shape.width = Config.GLOW_WIDTH;
        this.shape.height = Config.GLOW_HEIGHT;
        this.shape.color = Config.GLOW_COLOR;
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
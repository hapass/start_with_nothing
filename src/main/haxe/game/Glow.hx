package game;

import engine.math.Vec2;
import engine.graphics.Renderer;

class Glow {
    public var shape:Quad = new Quad();
    public var currentSpeed:Vec2<Float> = new Vec2<Float>();
    public var position:Vec2<Float> = new Vec2<Float>();

    public var topLeftCornerCell:Vec2<Int> = new Vec2<Int>();
    public var topRightCornerCell:Vec2<Int> = new Vec2<Int>();
    public var bottomLeftCornerCell:Vec2<Int> = new Vec2<Int>();
    public var bottomRightCornerCell:Vec2<Int> = new Vec2<Int>();

    public var topLeftCornerPreviousCell:Vec2<Int> = new Vec2<Int>();
    public var topRightCornerPreviousCell:Vec2<Int> = new Vec2<Int>();
    public var bottomLeftCornerPreviousCell:Vec2<Int> = new Vec2<Int>();
    public var bottomRightCornerPreviousCell:Vec2<Int> = new Vec2<Int>();

    public var isTopIntersecting:Bool = false;
    public var isBottomIntersecting:Bool = false;
    public var isLeftIntersecting:Bool = false;
    public var isRightIntersecting:Bool = false;
    public var isExitIntersecting:Bool = false;
    public var isOutOfScreen:Bool = false;

    public function new() {
        this.shape.width = Config.GLOW_WIDTH;
        this.shape.height = Config.GLOW_HEIGHT;
        this.shape.color = Config.GLOW_COLOR;
    }

    public function move() {
        setPosition(this.position.x + this.currentSpeed.x, this.position.y + this.currentSpeed.y);
    }

    public function setPosition(x:Float, y:Float) {
        this.topLeftCornerPreviousCell.set(this.topLeftCornerCell.x, this.topLeftCornerCell.y);
        this.topRightCornerPreviousCell.set(this.topRightCornerCell.x, this.topRightCornerCell.y);
        this.bottomLeftCornerPreviousCell.set(this.bottomLeftCornerCell.x, this.bottomLeftCornerCell.y);
        this.bottomRightCornerPreviousCell.set(this.bottomRightCornerCell.x, this.bottomRightCornerCell.y);
        this.position.set(x, y);
        this.shape.position = this.position;
        this.topLeftCornerCell.set(getColumn(this.position.x), getRow(this.position.y));
        this.topRightCornerCell.set(getColumn(this.position.x + Config.GLOW_WIDTH - 1), getRow(this.position.y));
        this.bottomLeftCornerCell.set(getColumn(this.position.x), getRow(this.position.y + Config.GLOW_HEIGHT));
        this.bottomRightCornerCell.set(getColumn(this.position.x + Config.GLOW_WIDTH - 1), getRow(this.position.y + Config.GLOW_HEIGHT));
    }

    public function isTop(cell:Vec2<Int>):Bool {
        return cell == this.topLeftCornerCell || cell == this.topRightCornerCell;
    }

    public function isBottom(cell:Vec2<Int>):Bool {
        return cell == this.bottomLeftCornerCell || cell == this.bottomRightCornerCell;
    }

    public function isRight(cell:Vec2<Int>):Bool {
        return cell == this.bottomRightCornerCell || cell == this.topRightCornerCell;
    }

    public function isLeft(cell:Vec2<Int>):Bool {
        return cell == this.bottomLeftCornerCell || cell == this.topLeftCornerCell;
    }

    private function getColumn(x:Float):Int {
        return Std.int(x / Config.BRUSH_WIDTH);
    }

    private function getRow(y:Float):Int {
        return Std.int(y / Config.BRUSH_HEIGHT);
    }
}
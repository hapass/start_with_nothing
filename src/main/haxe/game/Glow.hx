package game;

import engine.Light;
import engine.Debug;
import engine.Vec2;
import engine.Quad;

class Glow {
    public var shape:Quad = new Quad();
    public var currentSpeed:Vec2<Float> = new Vec2Float();
    public var position:Vec2<Float> = new Vec2Float();

    public var light:Light = new Light();
    public var isAnimatingLight:Bool = false;
    public var lightSpeed:Float = 0.0;

    public var topLeftCornerCell:Vec2<Int> = new Vec2Int();
    public var topRightCornerCell:Vec2<Int> = new Vec2Int();
    public var bottomLeftCornerCell:Vec2<Int> = new Vec2Int();
    public var bottomRightCornerCell:Vec2<Int> = new Vec2Int();

    public var topLeftCornerPreviousCell:Vec2<Int> = new Vec2Int();
    public var topRightCornerPreviousCell:Vec2<Int> = new Vec2Int();
    public var bottomLeftCornerPreviousCell:Vec2<Int> = new Vec2Int();
    public var bottomRightCornerPreviousCell:Vec2<Int> = new Vec2Int();

    public var isExitIntersecting:Bool = false;
    public var isOutOfScreen:Bool = false;

    public function new() {
        this.shape.width = Config.GLOW_WIDTH;
        this.shape.height = Config.GLOW_HEIGHT;
        this.shape.color = Config.GLOW_COLOR;
    }

    public function moveHorizontally() {
        setPosition(this.position.x + this.currentSpeed.x, this.position.y);
    }

    public function moveVertically() {
        setPosition(this.position.x, this.position.y + this.currentSpeed.y);
    }

    public function setPosition(x:Float, y:Float) {
        var topLeftCornerCellx = this.topLeftCornerCell.x;
        var topLeftCornerCelly = this.topLeftCornerCell.y;
        var topRightCornerCelly = this.topRightCornerCell.y;
        var topRightCornerCellx = this.topRightCornerCell.x;
        var bottomLeftCornerCellx = this.bottomLeftCornerCell.x;
        var bottomLeftCornerCelly = this.bottomLeftCornerCell.y;
        var bottomRightCornerCellx = this.bottomRightCornerCell.x;
        var bottomRightCornerCelly = this.bottomRightCornerCell.y;

        this.position.set(x, y);
        this.shape.position = this.position;
        this.light.position.set(this.position.x + Config.GLOW_WIDTH / 2, this.position.y + Config.GLOW_HEIGHT / 2);

        this.topLeftCornerCell.set(getColumn(this.position.x), getRow(this.position.y));
        this.topRightCornerCell.set(getColumn(this.position.x + Config.GLOW_WIDTH - 1), getRow(this.position.y));
        this.bottomLeftCornerCell.set(getColumn(this.position.x), getRow(this.position.y + Config.GLOW_HEIGHT - 1));
        this.bottomRightCornerCell.set(getColumn(this.position.x + Config.GLOW_WIDTH - 1), getRow(this.position.y + Config.GLOW_HEIGHT - 1));
        
        if (topLeftCornerCellx != this.topLeftCornerCell.x ||
            topLeftCornerCelly != this.topLeftCornerCell.y) {
            this.topLeftCornerPreviousCell.set(topLeftCornerCellx, topLeftCornerCelly);
        }

        if (topRightCornerCelly != this.topRightCornerCell.y ||
            topRightCornerCellx != this.topRightCornerCell.x) {
            this.topRightCornerPreviousCell.set(topRightCornerCellx, topRightCornerCelly);
        }

        if (bottomLeftCornerCellx != this.bottomLeftCornerCell.x ||
            bottomLeftCornerCelly != this.bottomLeftCornerCell.y) {
            this.bottomLeftCornerPreviousCell.set(bottomLeftCornerCellx, bottomLeftCornerCelly);
        }

        if (bottomRightCornerCellx != this.bottomRightCornerCell.x ||
            bottomRightCornerCelly != this.bottomRightCornerCell.y) {
            this.bottomRightCornerPreviousCell.set(bottomRightCornerCellx, bottomRightCornerCelly);
        }

        Debug.log('Cell previous ${this.bottomLeftCornerPreviousCell.y}');
        Debug.log('Cell current ${this.bottomLeftCornerCell.y}');
        Debug.log('Position ${this.position.y}');
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
        return Math.floor(x / Config.BRUSH_WIDTH);
    }

    private function getRow(y:Float):Int {
        return Math.floor(y / Config.BRUSH_HEIGHT);
    }
}
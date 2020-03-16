package game;

import game.Level.Cell;
import engine.Light;
import engine.Debug;
import engine.Vec2;
import engine.Quad;

class Glow {
    public var shape:Quad = new Quad();
    public var currentSpeed:Vec2 = new Vec2();
    public var position:Vec2 = new Vec2();

    public var light:Light = new Light();
    public var isAnimatingLight:Bool = false;
    public var lightSpeed:Float = 0.0;

    public var topLeftCornerCell:Cell = new Cell();
    public var topRightCornerCell:Cell = new Cell();
    public var bottomLeftCornerCell:Cell = new Cell();
    public var bottomRightCornerCell:Cell = new Cell();

    public var topLeftCornerCellTemp:Cell = new Cell();
    public var topRightCornerCellTemp:Cell = new Cell();
    public var bottomLeftCornerCellTemp:Cell = new Cell();
    public var bottomRightCornerCellTemp:Cell = new Cell();

    public var topLeftCornerPreviousCell:Cell = new Cell();
    public var topRightCornerPreviousCell:Cell = new Cell();
    public var bottomLeftCornerPreviousCell:Cell = new Cell();
    public var bottomRightCornerPreviousCell:Cell = new Cell();

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
        this.topLeftCornerCellTemp.copy(this.topLeftCornerCell);
        this.topRightCornerCellTemp.copy(this.topRightCornerCell);
        this.bottomLeftCornerCellTemp.copy(this.bottomLeftCornerCell);
        this.bottomRightCornerCellTemp.copy(this.bottomRightCornerCell);

        this.position.set(x, y);
        this.shape.position = this.position;
        this.light.position.set(this.position.x + Config.GLOW_WIDTH / 2, this.position.y + Config.GLOW_HEIGHT / 2);

        this.topLeftCornerCell.set(getColumn(this.position.x), getRow(this.position.y));
        this.topRightCornerCell.set(getColumn(this.position.x + Config.GLOW_WIDTH - 1), getRow(this.position.y));
        this.bottomLeftCornerCell.set(getColumn(this.position.x), getRow(this.position.y + Config.GLOW_HEIGHT - 1));
        this.bottomRightCornerCell.set(getColumn(this.position.x + Config.GLOW_WIDTH - 1), getRow(this.position.y + Config.GLOW_HEIGHT - 1));
        
        if (!this.topLeftCornerCell.equals(this.topLeftCornerCellTemp)) {
            this.topLeftCornerPreviousCell.copy(this.topLeftCornerCellTemp);
        }

        if (!this.topRightCornerCell.equals(this.topRightCornerCellTemp)) {
            this.topRightCornerPreviousCell.copy(this.topRightCornerCellTemp);
        }

        if (!this.bottomLeftCornerCell.equals(this.bottomLeftCornerCellTemp)) {
            this.bottomLeftCornerPreviousCell.copy(this.bottomLeftCornerCellTemp);
        }

        if (!this.bottomRightCornerCell.equals(this.bottomRightCornerCellTemp)) {
            this.bottomRightCornerPreviousCell.copy(this.bottomRightCornerCellTemp);
        }

        Debug.log('Cell previous ${this.bottomLeftCornerPreviousCell.y}');
        Debug.log('Cell current ${this.bottomLeftCornerCell.y}');
        Debug.log('Position ${this.position.y}');
    }

    public function isTop(cell:Cell):Bool {
        return cell == this.topLeftCornerCell || cell == this.topRightCornerCell;
    }

    public function isBottom(cell:Cell):Bool {
        return cell == this.bottomLeftCornerCell || cell == this.bottomRightCornerCell;
    }

    public function isRight(cell:Cell):Bool {
        return cell == this.bottomRightCornerCell || cell == this.topRightCornerCell;
    }

    public function isLeft(cell:Cell):Bool {
        return cell == this.bottomLeftCornerCell || cell == this.topLeftCornerCell;
    }

    private function getColumn(x:Float):Int {
        return Math.floor(x / Config.BRUSH_WIDTH);
    }

    private function getRow(y:Float):Int {
        return Math.floor(y / Config.BRUSH_HEIGHT);
    }
}
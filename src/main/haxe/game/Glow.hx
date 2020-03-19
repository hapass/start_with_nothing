package game;

import engine.Debug;
import js.html.TableRowElement;
import engine.Color;
import engine.Key;
import engine.Light;
import engine.Vec2;
import engine.Quad;
import game.Level;

using engine.FloatExtensions;

class Glow {
    public var position:Vec2;
    public var shape:Quad;

    public var currentSpeed:Vec2 = new Vec2();

    public var light:Light = new Light();
    public var isAnimatingLight:Bool = false;
    public var lightAnimationTick:Int = 0;
    public var bezierAnimationCurve:Bezier;

    public var jumpCount:Int = 0;


    public function new(position:Vec2) {
        this.position = position;
        this.light.position.x = getCenter(this.position.x);
        this.light.position.y = getCenter(this.position.y);
        this.shape = new Quad(Config.GLOW_COLOR, Config.TILE_SIZE, this.position);
        this.bezierAnimationCurve = new Bezier();
    }

    public function update(level:Level, tickTime:Float) {
        emitLight(tickTime);
        calculateSpeed();
        move(level);
    }

    private function calculateSpeed() {
        this.currentSpeed.y += Config.GLOW_FALL_ACCELERATION;

        if (Key.RIGHT.isPressed()) {
            if (this.currentSpeed.x.equals(0)) {
                this.currentSpeed.x = Config.GLOW_MIN_SPEED;
            } 
            else {
                this.currentSpeed.x = Math.min(
                    this.currentSpeed.x + Config.GLOW_ACCELERATION,
                    Config.GLOW_MAX_SPEED
                );
            }
        }
        else if (Key.LEFT.isPressed()) {
            if (this.currentSpeed.x.equals(0)) {
                this.currentSpeed.x = -Config.GLOW_MIN_SPEED;
            } 
            else {
                this.currentSpeed.x = Math.max(
                    this.currentSpeed.x - Config.GLOW_ACCELERATION,
                    -Config.GLOW_MAX_SPEED
                );
            }
        }
        else {
            this.currentSpeed.x = 0;
        }

        if (Key.SPACE.wasPressed() && jumpCount > 0) {
            this.currentSpeed.y = Config.GLOW_JUMP_ACCELERATION;
            jumpCount--;
        }
    }

    private function move(level:Level) {
        moveHorizontally(this.position.x + this.currentSpeed.x, level);
        moveVertically(this.position.y + this.currentSpeed.y, level);
    }

    private function moveHorizontally(x:Float, level:Level) {
        if (x.equals(this.position.x)) {
            return;
        }

        if (x < this.position.x) {
            var column = getTileIndex(x - 1);
            var top = level.getTileType(getTileIndex(this.position.y), column);
            var bottom = level.getTileType(getTileIndex(getEnd(this.position.y)), column);

            if (top == Wall || bottom == Wall)
                this.position.x = getPosition(column + 1);
            else
                this.position.x = x;
        }
        else {
            var column = getTileIndex(getEnd(x) + 1);
            var top = level.getTileType(getTileIndex(this.position.y), column);
            var bottom = level.getTileType(getTileIndex(getEnd(this.position.y)), column);

            if (top == Wall || bottom == Wall)
                this.position.x = getPosition(column - 1);
            else
                this.position.x = x;
        }

        this.light.position.x = getCenter(this.position.x);
    }

    private function moveVertically(y:Float, level:Level) {
        if (y.equals(this.position.y)) {
            return;
        }

        if (y < this.position.y) {
            var row = getTileIndex(y - 1);
            var left = level.getTileType(row, getTileIndex(this.position.x));
            var right = level.getTileType(row, getTileIndex(getEnd(this.position.x)));

            if (left == Wall || right == Wall) {
                this.position.y = getPosition(row + 1);
                this.currentSpeed.y = 0;
            }
            else
                this.position.y = y;
        }
        else {
            var row = getTileIndex(getEnd(y) + 1);
            var left = level.getTileType(row, getTileIndex(this.position.x));
            var right = level.getTileType(row, getTileIndex(getEnd(this.position.x)));

            if (left == Wall || right == Wall) {
                this.position.y = getPosition(row - 1);
                this.currentSpeed.y = 0;
                this.jumpCount = Config.JUMP_COUNT;
            }
            else
                this.position.y = y;
        }

        this.light.position.y = getCenter(this.position.y);
    }

    private function getTileIndex(offset:Float):Int {
        return Math.floor(offset / Config.TILE_SIZE);
    }

    private function getPosition(tileIndex:Int):Float {
        return tileIndex * Config.TILE_SIZE;
    }

    private function getCenter(offset:Float):Float {
        return offset + Config.TILE_SIZE / 2;
    }

    private function getEnd(offset:Float):Float {
        return offset + Config.TILE_SIZE - 1;
    }

    private function emitLight(tickTime:Float) {
        if (Key.SPACE.wasPressed()) {
            this.light.color.r = Color.correctColor(Math.random());
            this.light.color.g = Color.correctColor(Math.random());
            this.light.color.b = Color.correctColor(Math.random());
            this.lightAnimationTick = 0;
            this.isAnimatingLight = true;
        }

        if (this.isAnimatingLight) {
            if (this.lightAnimationTick == this.bezierAnimationCurve.bezier.length) {
                this.isAnimatingLight = false;
                this.light.radius = 0.0;
            } 
            else {
                this.light.radius = Config.GLOW_LIGHT_MIN_RADIUS + (Config.GLOW_LIGHT_MAX_RADIUS - Config.GLOW_LIGHT_MIN_RADIUS) * this.bezierAnimationCurve.bezier[this.lightAnimationTick];
            }

            Debug.log('Light radius: ${this.light.radius}');

            this.lightAnimationTick++;
        }
    }
}
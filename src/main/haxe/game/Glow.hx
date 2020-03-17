package game;

import engine.Keyboard;
import engine.Light;
import engine.Vec2;
import engine.Quad;
import game.Level;

using engine.FloatExtensions;

class Glow {
    public var shape:Quad = new Quad();
    public var currentSpeed:Vec2 = new Vec2();
    public var position:Vec2 = new Vec2();

    public var light:Light = new Light();
    public var isAnimatingLight:Bool = false;
    public var lightSpeed:Float = 0.0;

    public var jumpCount:Int = 0;

    public function new() {
        this.shape.position = this.position;
        this.shape.width = Config.TILE_SIZE;
        this.shape.height = Config.TILE_SIZE;
        this.shape.color = Config.GLOW_COLOR;
    }

    public function update(level:Level) {
        emitLight();
        calculateSpeed();
        move(level);
    }

    private function calculateSpeed() {
        this.currentSpeed.add(0, Config.GLOW_FALL_ACCELERATION);

        if (Key.RIGHT.isPressed()) {
            this.currentSpeed.set(Config.GLOW_SPEED, this.currentSpeed.y);
        }
        else if (Key.LEFT.isPressed()) {
            this.currentSpeed.set(-Config.GLOW_SPEED, this.currentSpeed.y);
        }
        else {
            this.currentSpeed.set(0, this.currentSpeed.y);
        }

        if (Key.SPACE.wasPressed() && jumpCount > 0) {
            this.currentSpeed.set(this.currentSpeed.x, Config.GLOW_JUMP_ACCELERATION);
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
                this.currentSpeed.set(this.currentSpeed.x, 0);
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
                this.currentSpeed.set(this.currentSpeed.x, 0);
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

    private function emitLight() {
        if (Key.SPACE.wasPressed()) {
            this.lightSpeed = Config.GLOW_LIGHT_STARTING_SPEED;
            this.light.radius = Config.GLOW_LIGHT_MIN_RADIUS;
            this.isAnimatingLight = true;
        }

        if (this.isAnimatingLight) {
            this.lightSpeed += Config.GLOW_LIGHT_ACCELERATION;
            this.light.radius += this.lightSpeed;
            
            if (this.light.radius > Config.GLOW_LIGHT_MAX_RADIUS) {
                this.isAnimatingLight = false;
                this.light.radius = 0.0;
            }
        }
    }
}
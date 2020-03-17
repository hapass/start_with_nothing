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

    public var isExitIntersecting:Bool = false;
    public var isOutOfScreen:Bool = false;

    public function new() {
        this.shape.position = this.position;
        this.shape.width = Config.TILE_SIZE;
        this.shape.height = Config.TILE_SIZE;
        this.shape.color = Config.GLOW_COLOR;
    }

    public function update(level:Level) {
        calculateSpeed();
        move(level);
        emitLight();
    }

    private function calculateSpeed() {
        this.currentSpeed.add(0, Config.GLOW_FALL_ACCELERATION);

        if (Key.RIGHT.currentState == Key.KEY_DOWN) {
            this.currentSpeed.set(Config.GLOW_SPEED, this.currentSpeed.y);
        }
        else if (Key.LEFT.currentState == Key.KEY_DOWN) {
            this.currentSpeed.set(-Config.GLOW_SPEED, this.currentSpeed.y);
        }
        else {
            this.currentSpeed.set(0, this.currentSpeed.y);
        }

        if (Key.SPACE.currentState == Key.KEY_DOWN && Key.SPACE.previousState == Key.KEY_UP) {
            this.currentSpeed.add(0, Config.GLOW_JUMP_ACCELERATION);
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
            /*
            Moving left.
            Detection points:
            o***
             ***
            o***
            */
            var column = Math.floor((x - 1) / Config.TILE_SIZE);
            var top = level.getIntersection(Math.floor(this.position.y / Config.TILE_SIZE), column);
            var bottom = level.getIntersection(Math.floor((this.position.y + Config.TILE_SIZE - 1) / Config.TILE_SIZE), column);

            if (top == 1 || bottom == 1)
                this.position.x = (column + 1) * Config.TILE_SIZE;
            else
                this.position.x = x;
        }
        else {
            /*
            Moving right.
            Detection points:
            ***o
            ***
            ***o
            */
            var column = Math.floor((x + Config.TILE_SIZE) / Config.TILE_SIZE);
            var top = level.getIntersection(Math.floor(this.position.y / Config.TILE_SIZE), column);
            var bottom = level.getIntersection(Math.floor((this.position.y + Config.TILE_SIZE - 1) / Config.TILE_SIZE), column);

            if (top == 1 || bottom == 1)
                this.position.x = (column - 1) * Config.TILE_SIZE;
            else
                this.position.x = x;
        }

        this.light.position.x = this.position.x + Config.TILE_SIZE / 2;
    }

    private function moveVertically(y:Float, level:Level) {
        if (y.equals(this.position.y)) {
            return;
        }

        if (y < this.position.y) {
            /*
            Moving up.
            Detection points:
            o o
            ***
            ***
            ***
            */
            var row = Math.floor((y - 1) / Config.TILE_SIZE);
            var left = level.getIntersection(row, Math.floor(this.position.x / Config.TILE_SIZE));
            var right = level.getIntersection(row, Math.floor((this.position.x + Config.TILE_SIZE - 1) / Config.TILE_SIZE));

            if (left == 1 || right == 1) {
                this.position.y = (row + 1) * Config.TILE_SIZE;
                this.currentSpeed.set(this.currentSpeed.x, 0);
            }
            else
                this.position.y = y;
        }
        else {
            /*
            Moving down.
            Detection points:
            ***
            ***
            ***
            o o
            */
            var row = Math.floor((y + Config.TILE_SIZE) / Config.TILE_SIZE);
            var left = level.getIntersection(row, Math.floor(this.position.x / Config.TILE_SIZE));
            var right = level.getIntersection(row, Math.floor((this.position.x + Config.TILE_SIZE - 1) / Config.TILE_SIZE));

            if (left == 1 || right == 1) {
                this.position.y = (row - 1) * Config.TILE_SIZE;
                this.currentSpeed.set(this.currentSpeed.x, 0);
            }
            else
                this.position.y = y;
        }

        this.light.position.y = this.position.y + Config.TILE_SIZE / 2;
    }

    private function emitLight() {
        if (Key.SHIFT.currentState == Key.KEY_DOWN && Key.SHIFT.previousState == Key.KEY_UP) {
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
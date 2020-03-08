package game;

import engine.graphics.Renderer;
import engine.loop.GameLoop;
import engine.loop.GameLoopObserver;
import engine.math.Vec2;
import engine.input.Keyboard;
import lang.Promise;
import engine.input.Key;
import js.Browser;

enum GameResult {
    Quit;
    Restart;
}

class Main {
    static function main() {
        launch();
    }

    public static function launch() {
        new Game().run().then(function(result:GameResult) {
            switch(result) {
                case GameResult.Restart:
                    Browser.alert("You've lost. Try again!");
                    launch();
                case GameResult.Quit:
                    Browser.alert("You won!");
            }
        });
    }
}

class Game implements GameLoopObserver {
    private var loop:GameLoop = new GameLoop();
    private var keyboard:Keyboard = new Keyboard([Key.SPACE, Key.RIGHT, Key.LEFT]);
    private var renderer:Renderer = new Renderer(Config.GAME_WIDTH, Config.GAME_HEIGHT);

    private var glow:Glow = new Glow();
    private var level:Level = new Level();
    private var gameResult:Promise<GameResult> = new Promise<GameResult>();

    private var bottomIntersectionOffset:Vec2 = new Vec2();

    public function new() {}

    public function run():Promise<GameResult> {
        this.glow.setPosition(this.level.glowPosition.x, this.level.glowPosition.y);
        this.renderer.add([glow.shape]);
        this.renderer.add(this.level.compositeShape);
        this.loop.start(this);
        return this.gameResult;
    }

    public function update(timestamp:Float):Void {
        this.keyboard.update();

        //move
        this.glow.currentSpeed.add(0, Config.GLOW_FALL_ACCELERATION);

        if (Key.RIGHT.currentState == Key.KEY_DOWN) {
            this.glow.currentSpeed.set(Config.GLOW_SPEED, this.glow.currentSpeed.y);
        }
        else if (Key.LEFT.currentState == Key.KEY_DOWN) {
            this.glow.currentSpeed.set(-Config.GLOW_SPEED, this.glow.currentSpeed.y);
        }
        else {
            this.glow.currentSpeed.set(0, this.glow.currentSpeed.y);
        }

        if (Key.SPACE.currentState == Key.KEY_DOWN && Key.SPACE.previousState == Key.KEY_UP && this.glow.isBottomIntersecting) {
            this.glow.currentSpeed.add(0, Config.GLOW_JUMP_ACCELERATION);
        }

        this.glow.move();

        //intersect
        checkIntersections();

        //correct movement
        if (this.glow.isLeftIntersecting) {
            this.glow.setPosition(getColumn(this.glow.center) * Config.BRUSH_WIDTH, this.glow.position.y);
        }

        if (this.glow.isRightIntersecting) {
            this.glow.setPosition(getColumn(this.glow.center) * Config.BRUSH_WIDTH, this.glow.position.y);
        }

        if (this.glow.isBottomIntersecting || this.glow.isTopIntersecting) {
            this.glow.currentSpeed.set(this.glow.currentSpeed.x, 0);
            this.glow.setPosition(this.glow.position.x, getRow(this.glow.center) * Config.BRUSH_HEIGHT);
        }

        //death
        if (isOutOfScreen()) {
            stop(GameResult.Restart);
            return;
        }

        //win
        if (this.glow.isYellowSquareIntersecting) {
            stop(GameResult.Quit);
            return;
        }

        this.renderer.draw();
    }

    private function getColumn(point:Vec2):Int {
        return Std.int(point.x / Config.BRUSH_WIDTH);
    }

    private function getRow(point:Vec2):Int {
        return Std.int(point.y / Config.BRUSH_HEIGHT);
    }

    private function isOutOfScreen() {
        return this.glow.position.x > Config.GAME_WIDTH ||
            this.glow.position.x < 0 ||
            this.glow.position.y > Config.GAME_HEIGHT ||
            this.glow.position.y < 0;
    }

    private function checkIntersections() {
        this.glow.isBottomIntersecting = false;
        this.glow.isLeftIntersecting = false;
        this.glow.isRightIntersecting = false;
        this.glow.isTopIntersecting = false;
        this.glow.isYellowSquareIntersecting = false;

        setGlowIntersections(this.glow.topLeftCorner);
        setGlowIntersections(this.glow.topRightCorner);
        setGlowIntersections(this.glow.bottomRightCorner);
        setGlowIntersections(this.glow.bottomLeftCorner);
    }

    private function setGlowIntersections(point:Vec2) {
        var centerColumn = getColumn(this.glow.center);
        var centerRow = getRow(this.glow.center);

        var columnIndex = getColumn(point);
        var rowIndex = getRow(point);

        if (rowIndex < level.data.length && columnIndex < level.data[rowIndex].length) {
            if(level.data[rowIndex][columnIndex] == 1) {
                if (rowIndex < centerRow) {
                    this.glow.isTopIntersecting = true;
                }

                if (rowIndex > centerRow) {
                    this.glow.isBottomIntersecting = true;
                }

                if (columnIndex > centerColumn && rowIndex == centerRow) {
                    this.glow.isRightIntersecting = true;
                }

                if (columnIndex < centerColumn && rowIndex == centerRow) {
                    this.glow.isLeftIntersecting = true;
                }
            }
            else if (level.data[rowIndex][columnIndex] == 2) {
                this.glow.isYellowSquareIntersecting = true;
            }
        }
    }

    private function stop(result:GameResult) {
        this.loop.stop();
        this.renderer.dispose();
        this.keyboard.dispose();
        this.gameResult.resolve(result);
    }
}
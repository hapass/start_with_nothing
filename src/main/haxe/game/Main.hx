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

    private var bottomIntersectionOffset:Vec2<Float> = new Vec2<Float>();

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
            this.glow.setPosition(this.glow.topLeftCornerPreviousCell.x * Config.BRUSH_WIDTH, this.glow.position.y);
            this.glow.setPosition(this.glow.topLeftCornerPreviousCell.x * Config.BRUSH_WIDTH, this.glow.position.y);
        }

        if (this.glow.isRightIntersecting) {
            this.glow.setPosition(this.glow.topRightCornerPreviousCell.x * Config.BRUSH_WIDTH, this.glow.position.y);
            this.glow.setPosition(this.glow.topRightCornerPreviousCell.x * Config.BRUSH_WIDTH, this.glow.position.y);
        }

        if (this.glow.isBottomIntersecting) {
            this.glow.currentSpeed.set(this.glow.currentSpeed.x, 0);
            this.glow.setPosition(this.glow.position.x, this.glow.bottomRightCornerPreviousCell.y * Config.BRUSH_HEIGHT);
            this.glow.setPosition(this.glow.position.x, this.glow.bottomRightCornerPreviousCell.y * Config.BRUSH_HEIGHT);
        }

        if (this.glow.isTopIntersecting) {
            this.glow.currentSpeed.set(this.glow.currentSpeed.x, 0);
            this.glow.setPosition(this.glow.position.x, this.glow.topRightCornerPreviousCell.y * Config.BRUSH_HEIGHT);
            this.glow.setPosition(this.glow.position.x, this.glow.topRightCornerPreviousCell.y * Config.BRUSH_HEIGHT);
        }

        //death
        if (this.glow.isOutOfScreen) {
            stop(GameResult.Restart);
            return;
        }

        //win
        if (this.glow.isExitIntersecting) {
            stop(GameResult.Quit);
            return;
        }

        this.renderer.draw();
    }

    private function checkIntersections() {
        this.glow.isBottomIntersecting = false;
        this.glow.isLeftIntersecting = false;
        this.glow.isRightIntersecting = false;
        this.glow.isTopIntersecting = false;
        this.glow.isExitIntersecting = false;
        this.glow.isOutOfScreen = false;

        setGlowIntersections(this.glow.topLeftCornerCell, this.glow.topLeftCornerPreviousCell);
        setGlowIntersections(this.glow.topRightCornerCell, this.glow.topRightCornerPreviousCell);
        setGlowIntersections(this.glow.bottomRightCornerCell, this.glow.bottomRightCornerPreviousCell);
        setGlowIntersections(this.glow.bottomLeftCornerCell, this.glow.bottomLeftCornerPreviousCell);
    }

    private function setGlowIntersections(cell:Vec2<Int>, previousCell:Vec2<Int>) {
        if (level.isCellValid(cell)) {
            if(level.getCellType(cell) == 1) {
                if (cell.y < previousCell.y && this.glow.isTop(cell)) {
                    this.glow.isTopIntersecting = true;
                }

                if (cell.y > previousCell.y && this.glow.isBottom(cell)) {
                    this.glow.isBottomIntersecting = true;
                }

                if (cell.x > previousCell.x && this.glow.isRight(cell)) {
                    this.glow.isRightIntersecting = true;
                }

                if (cell.x < previousCell.x && this.glow.isLeft(cell)) {
                    this.glow.isLeftIntersecting = true;
                }
            }
            else if (level.getCellType(cell) == 2) {
                this.glow.isExitIntersecting = true;
            }
        }
        else {
            this.glow.isOutOfScreen = true;
        }
    }

    private function stop(result:GameResult) {
        this.loop.stop();
        this.renderer.dispose();
        this.keyboard.dispose();
        this.gameResult.resolve(result);
    }
}
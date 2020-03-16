package game;

import engine.Renderer;
import engine.GameLoop;
import engine.Vec2;
import engine.Keyboard;
import engine.Promise;
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

class Game {
    private var animatingGlow:Bool = false;
    private var glowRadiusSpeed:Float = 0.0;

    private var loop:GameLoop = new GameLoop();
    private var keyboard:Keyboard = new Keyboard([Key.SPACE, Key.RIGHT, Key.LEFT, Key.SHIFT]);
    private var renderer:Renderer = new Renderer(Config.GAME_WIDTH, Config.GAME_HEIGHT);

    private var glow:Glow = new Glow();
    private var level:Level = new Level();
    private var gameResult:Promise<GameResult> = new Promise<GameResult>();

    private var bottomIntersectionOffset:Vec2<Float> = new Vec2Float();

    public function new() {}

    public function run():Promise<GameResult> {
        this.glow.setPosition(this.level.glowPosition.x, this.level.glowPosition.y);
        this.renderer.add([glow.shape]);
        this.renderer.setLight(glow.light);
        this.renderer.add(this.level.compositeShape);
        this.loop.start(this.update);
        return this.gameResult;
    }

    public function update(timestamp:Float):Void {
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

        if (Key.SPACE.currentState == Key.KEY_DOWN && Key.SPACE.previousState == Key.KEY_UP) {
            this.glow.lightSpeed = Config.GLOW_LIGHT_STARTING_SPEED;
            this.glow.light.radius = Config.GLOW_LIGHT_MIN_RADIUS;
            this.glow.isAnimatingLight = true;
            this.glow.currentSpeed.add(0, Config.GLOW_JUMP_ACCELERATION);
        }

        //process light animation
        if (this.glow.isAnimatingLight) {
            this.glow.lightSpeed += Config.GLOW_LIGHT_ACCELERATION;
            this.glow.light.radius += this.glow.lightSpeed;
            
            if (this.glow.light.radius > Config.GLOW_LIGHT_MAX_RADIUS) {
                this.glow.isAnimatingLight = false;
            }
        }

        //intersect
        this.glow.moveHorizontally();
        checkIntersections(true);

        this.glow.moveVertically();
        checkIntersections(false);

        this.renderer.draw();
    }

    private function checkIntersections(isHorizontal:Bool) {
        setGlowIntersections(this.glow.topLeftCornerCell, this.glow.topLeftCornerPreviousCell, isHorizontal);
        setGlowIntersections(this.glow.topRightCornerCell, this.glow.topRightCornerPreviousCell, isHorizontal);
        setGlowIntersections(this.glow.bottomRightCornerCell, this.glow.bottomRightCornerPreviousCell, isHorizontal);
        setGlowIntersections(this.glow.bottomLeftCornerCell, this.glow.bottomLeftCornerPreviousCell, isHorizontal);
    }

    private function setGlowIntersections(cell:Vec2<Int>, previousCell:Vec2<Int>, isHorizontal:Bool) {
        if (level.isCellValid(cell)) {
            if(level.getCellType(cell) == 1) {
                if (isHorizontal)
                {
                    if ((cell.x > previousCell.x && this.glow.isRight(cell)) || 
                        (cell.x < previousCell.x && this.glow.isLeft(cell))) {
                        this.glow.setPosition(previousCell.x * Config.BRUSH_WIDTH, this.glow.position.y);
                    }
                }
                else
                {
                    if ((cell.y < previousCell.y && this.glow.isTop(cell)) || 
                        (cell.y > previousCell.y && this.glow.isBottom(cell))) {
                        this.glow.currentSpeed.set(this.glow.currentSpeed.x, 0);
                        this.glow.setPosition(this.glow.position.x, previousCell.y * Config.BRUSH_HEIGHT);
                    }
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
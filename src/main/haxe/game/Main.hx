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
    private var loop: GameLoop;
    private var keyboard: Keyboard;
    private var renderer: Renderer;

    private var glow: Glow;
    private var level: Level;
    private var gameResult: Promise<GameResult>;

    public function new() {
        this.keyboard = new Keyboard([Key.SPACE, Key.RIGHT, Key.LEFT]);

        this.renderer = new Renderer(Config.GAME_WIDTH, Config.GAME_HEIGHT);
        this.loop = new GameLoop();
        this.gameResult = new Promise<GameResult>();
    }

    public function run():Promise<GameResult> {
        this.level = new Level();
        this.renderer.add(this.level.compositeShape);

        this.glow = new Glow(this.level.glowPosition);
        this.renderer.add([glow.shape]);

        this.loop.start(this);
        return this.gameResult;
    }

    public function update(timestamp:Float):Void {
        try {
            this.keyboard.update();

            //gravity
            this.glow.currentSpeed = this.glow.currentSpeed.add(this.glow.acceleration);

            //jump
            checkIntersections();
            if (Key.SPACE.currentState == Key.KEY_DOWN && 
                Key.SPACE.previousState == Key.KEY_UP && 
                this.glow.isBottomIntersecting) {
                this.glow.currentSpeed = new Vec2(0, -Config.GLOW_JUMP_ACCELERATION);
            }

            //movement
            if (Key.RIGHT.currentState == Key.KEY_DOWN)
            {
                this.glow.currentSpeed = new Vec2(Config.GLOW_SPEED, this.glow.currentSpeed.y);
            }
            else if (Key.LEFT.currentState == Key.KEY_DOWN)
            {
                this.glow.currentSpeed = new Vec2(-Config.GLOW_SPEED, this.glow.currentSpeed.y);
            }
            else
            {
                this.glow.currentSpeed = new Vec2(0, this.glow.currentSpeed.y);
            }

            this.glow.move(this.glow.currentSpeed);

            //obstacles
            checkIntersections();

            if (this.glow.isLeftIntersecting)
            {
                var columnIndex = Std.int(this.glow.center.x / Config.BRUSH_WIDTH);
                this.glow.move(new Vec2(columnIndex * Config.BRUSH_WIDTH - this.glow.position.x, 0));
            }

            if (this.glow.isRightIntersecting)
            {
                var columnIndex = Std.int(this.glow.center.x / Config.BRUSH_WIDTH);
                this.glow.move(new Vec2(columnIndex * Config.BRUSH_WIDTH - this.glow.position.x, 0));
            }

            checkIntersections();
            if (this.glow.isBottomIntersecting || this.glow.isTopIntersecting)
            {
                this.glow.currentSpeed = new Vec2(this.glow.currentSpeed.x, 0);
                var rowIndex = Std.int(this.glow.center.y / Config.BRUSH_HEIGHT);
                var brushPosition = new Vec2(this.glow.position.x, rowIndex * Config.BRUSH_HEIGHT);
                var offset = brushPosition.subtract(this.glow.position);
                this.glow.move(offset);
            }

            //death
            if(isOutOfScreen()) {
                stop(GameResult.Restart);
            }

            this.renderer.draw();
        }
        catch (e:Dynamic) 
        {
            trace(e);
        }
    }

    private function isOutOfScreen() {
        return this.glow.position.x > Config.GAME_WIDTH ||
            this.glow.position.x < 0 ||
            this.glow.position.y > Config.GAME_HEIGHT ||
            this.glow.position.y < 0;
    }

    private function checkIntersections()
    {
        this.glow.isBottomIntersecting = false;
        this.glow.isLeftIntersecting = false;
        this.glow.isRightIntersecting = false;
        this.glow.isTopIntersecting = false;

        var centerColumn = Std.int(this.glow.center.x / Config.BRUSH_WIDTH);
        var centerRow = Std.int(this.glow.center.y / Config.BRUSH_HEIGHT);

        setGlowIntersections(this.glow.topLeftCorner, centerRow, centerColumn);
        setGlowIntersections(this.glow.topRightCorner, centerRow, centerColumn);
        setGlowIntersections(this.glow.bottomRightCorner, centerRow, centerColumn);
        setGlowIntersections(this.glow.bottomLeftCorner, centerRow, centerColumn);
    }

    private function setGlowIntersections(point: Vec2, centerRow:Int, centerColumn:Int) {
        var columnIndex = Std.int(point.x / Config.BRUSH_WIDTH);
        var rowIndex = Std.int(point.y / Config.BRUSH_HEIGHT);

        if (rowIndex < level.data.length && columnIndex < level.data[rowIndex].length)
        {
            if(level.data[rowIndex][columnIndex] == 1)
            {
                if (rowIndex < centerRow)
                {
                    this.glow.isTopIntersecting = true;
                }

                if (rowIndex > centerRow)
                {
                    this.glow.isBottomIntersecting = true;
                }

                if (columnIndex > centerColumn && rowIndex == centerRow)
                {
                    this.glow.isRightIntersecting = true;
                }

                if (columnIndex < centerColumn && rowIndex == centerRow)
                {
                    this.glow.isLeftIntersecting = true;
                }
            }
            else if (level.data[rowIndex][columnIndex] == 2)
            {
                stop(GameResult.Quit);
            }
        }
    }

    private function stop(result:GameResult) {
        this.loop.stop();
        this.renderer.dispose();
        this.keyboard.dispose();
        this.gameResult.resolve(result);
        throw "exit";
    }
}
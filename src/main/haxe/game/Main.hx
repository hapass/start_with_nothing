package game;

import engine.graphics.drawing.DrawingBoard;
import engine.loop.GameLoop;
import engine.loop.GameLoopObserver;
import engine.math.Vec2;
import engine.input.Keyboard;
import lang.Promise;
import engine.input.Key;

enum GameResult {
    Quit;
    Restart;
}

class Main {
    static function main() {
        launch();
    }

    public static function launch() {
        new Game().run().then(function(result:GameResult){
            switch(result) {
                case GameResult.Restart: launch();
                case GameResult.Quit:
            }
        });
    }
}

class Game implements GameLoopObserver {
    private var loop: GameLoop;
    private var keyboard: Keyboard;
    private var board: DrawingBoard;

    private var glow: Glow;
    private var level: Level;
    private var gameResult: Promise<GameResult>;

    public function new() {
        this.keyboard = new Keyboard([Key.SPACE]);

        this.board = new DrawingBoard(Config.GAME_WIDTH, Config.GAME_HEIGHT);
        this.loop = new GameLoop();
        this.gameResult = new Promise<GameResult>();
    }

    public function run():Promise<GameResult> {
        this.glow = new Glow();
        this.board.add(glow.shape);
        
        this.level = new Level();
        for (shape in this.level.compositeShape)
        {
            this.board.add(shape);
        }

        this.loop.subscribe(this);
        this.loop.start();

        return this.gameResult;
    }

    public function update(timestamp:Float):Void {
        this.keyboard.update();

        if (Key.SPACE.currentState == Key.KEY_DOWN && Key.SPACE.previousState == Key.KEY_UP) {
            fly();
        }

        applyGravity();
        move();

        if(isOutOfScreen()) {
            stop();
        }

        this.board.draw();
    }

    private function fly() {
        this.glow.currentSpeed = new Vec2(0, -Config.GLOW_FLIGHT_ACCELERATION);
    }

    private function applyGravity() {
        this.glow.currentSpeed = this.glow.currentSpeed.add(this.glow.acceleration);
    }

    private function move() {
        this.glow.position = this.glow.position.add(this.glow.currentSpeed);
        this.glow.shape.move(this.glow.currentSpeed);
    }

    private function isOutOfScreen() {
        return this.glow.position.x > Config.GAME_WIDTH ||
            this.glow.position.x < 0 ||
            this.glow.position.y > Config.GAME_HEIGHT ||
            this.glow.position.y < 0;
    }

    private function stop() {
        this.loop.stop();
        this.loop.unsubscribe(this);
        this.board.dispose();
        this.keyboard.dispose();
        this.gameResult.resolve(GameResult.Restart);
    }
}
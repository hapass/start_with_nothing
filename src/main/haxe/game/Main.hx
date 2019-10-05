package game;

import engine.graphics.drawing.DrawingBoard;
import engine.loop.GameLoop;
import engine.loop.GameLoopObserver;
import engine.input.Key;
import engine.input.Keyboard;
import lang.Promise;

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

class Game implements GameLoopObserver implements GlowLifetimeObserver {
    private var loop:GameLoop;
    private var keyboard:Keyboard;
    private var board:DrawingBoard;
    private var gameObjects:Array<GameObject>;
    private var spawner:LevelSpawner;
    private var gameResult:Promise<GameResult>;

    public function new() {
        this.keyboard = new Keyboard([Key.SPACE]);
        this.board = new DrawingBoard(GamePlayParameters.GAME_WIDTH, GamePlayParameters.GAME_HEIGHT);
        this.gameObjects = new Array<GameObject>();
        this.loop = new GameLoop();
        this.spawner = new LevelSpawner();
        this.gameResult = new Promise<GameResult>();
    }

    public function run():Promise<GameResult> {
        spawnGlow();
        spawnBrush();

        this.loop.subscribe(this);
        this.loop.start();

        return this.gameResult;
    }

    private function spawnGlow():Void {
        var glow:Glow = Glow.create();
        glow.subscribe(this);
        add(glow);
    }

    public function update(timestamp:Float):Void {
        this.keyboard.checkInput();

        removeDisposedGameObjects();
        updateAllGameObjects(timestamp);

        this.board.draw();
    }

    public function onGlowDeath():Void {
        stop();
        this.gameResult.resolve(GameResult.Restart);
    }

    private function stop() {
        this.loop.stop();
        this.loop.unsubscribe(this);
        removeDisposedGameObjects(true);
        this.board.dispose();
        this.keyboard.dispose();
    }

    private function spawnBrush() {
        var spawnResult = spawner.spawn();
        if(spawnResult.spawned) {
            add(spawnResult.gameObject);
        }
    }

    private function updateAllGameObjects(timestamp: Float) {
        for(gameObject in this.gameObjects) {
            gameObject.update(timestamp);
        }
    }

    private function add(gameObject:GameObject):Void {
        this.keyboard.subscribe(gameObject.getKeyboardObserver());

        var compositeShape = gameObject.getShape();
        for(shape in compositeShape) {
            this.board.add(shape);
        }

        this.gameObjects.push(gameObject);
    }

    private function removeDisposedGameObjects(force:Bool = false) {
        var activeObjects = [];
        for(gameObject in this.gameObjects) {
            if(gameObject.disposed || force) {
                for(shape in gameObject.getShape()) {
                    this.board.remove(shape);
                }
            }
            else {
                activeObjects.push(gameObject);
            }
        }
        this.gameObjects = activeObjects;
    }
}
package game;

import engine.graphics.drawing.DrawingBoard;
import engine.loop.GameLoop;
import engine.loop.GameLoopObserver;
import engine.input.Key;
import engine.input.Keyboard;
import engine.collisions.CollisionResolver;
import engine.collisions.CollisionObserver;
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

class Game implements GameLoopObserver implements CollisionObserver {
    private var loop:GameLoop;
    private var keyboard:Keyboard;
    private var board:DrawingBoard;
    private var gameObjects:Array<GameObject>;
    private var spawner:ObstacleSpawner;
    private var collisionResolver:CollisionResolver;
    private var gameResult:Promise<GameResult>;

    public function new() {
        this.keyboard = new Keyboard([Key.SPACE]);
        this.board = new DrawingBoard(GamePlayParameters.GAME_WIDTH, GamePlayParameters.GAME_HEIGHT);
        this.gameObjects = new Array<GameObject>();
        this.loop = new GameLoop();
        this.spawner = new ObstacleSpawner();
        this.collisionResolver = new CollisionResolver();
        this.gameResult = new Promise<GameResult>();
    }

    public function run():Promise<GameResult> {
        spawnBird();

        this.collisionResolver.subscribe(this);
        this.loop.subscribe(this);
        this.loop.start();

        return this.gameResult;
    }

    private function spawnBird():Void {
        Bird.create().then(function(bird:Bird) {
            add(bird);
        });
    }

    public function update(timestamp: Float):Void {
        this.keyboard.checkInput();

        spawnObstacleIfNecessary(timestamp);
        this.collisionResolver.resolve();

        removeDisposedGameObjects();
        updateAllGameObjects(timestamp);

        this.board.draw();
    }

    public function onCollision():Void {
        stop();
        this.gameResult.resolve(GameResult.Restart);
    }

    private function stop() {
        this.loop.stop();
        this.loop.unsubscribe(this);
        this.collisionResolver.unsubscribe(this);
        removeDisposedGameObjects(true);
        this.board.dispose();
        this.keyboard.dispose();
    }

    private function spawnObstacleIfNecessary(timestamp: Float) {
        var spawnResult = spawner.spawn(timestamp);

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

        var compositeCollider = gameObject.getCollider();
        for(collider in compositeCollider) {
            this.collisionResolver.addToCollisionGroup(gameObject.getCollisionGroupName(), collider);
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
                
                for(collider in gameObject.getCollider()) {
                    this.collisionResolver.removeFromCollisionGroup(gameObject.getCollisionGroupName(), collider);
                }
            }
            else {
                activeObjects.push(gameObject);
            }
        }
        this.gameObjects = activeObjects;
    }
}
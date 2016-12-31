package game;

import engine.graphics.drawing.DrawingBoard;

import engine.loop.GameLoop;
import engine.loop.GameLoopObserver;

import engine.input.Key;
import engine.input.Keyboard;

import engine.collisions.CollisionResolver;
import engine.collisions.Collider;
import engine.collisions.CollisionObserver;

class Main {
    static function main() {
        var game = new Game();
        game.start();
    }
}

class Game implements GameLoopObserver implements CollisionObserver {

    public static inline var WIDTH: Int = 800;
    public static inline var HEIGHT: Int = 600;

    private var loop: GameLoop;
    private var keyboard: Keyboard;
    private var board: DrawingBoard;
    private var gameObjects: Array<GameObject>;
    private var spawner: ObstacleSpawner;
    private var collisionResolver: CollisionResolver;

    public function new() {
        this.keyboard = new Keyboard([Key.SPACE]);
        this.board = new DrawingBoard(WIDTH, HEIGHT);
        this.gameObjects = new Array<GameObject>();
        this.loop = new GameLoop();
        this.spawner = new ObstacleSpawner();
        this.collisionResolver = new CollisionResolver();
    }

    public function start() {
        spawnBird();

        this.loop.subscribe(this);
        this.loop.start();
    }

    private function spawnBird(): Void {
        add(new Bird());
    }

    public function update(timestamp: Float) {
        this.keyboard.checkInput();

        removeDisposedGameObjects();
        spawnObstacleIfNecessary(timestamp);

        this.collisionResolver.resolve();

        updateAllGameObjects(timestamp);

        this.board.draw();
    }

    public function onCollision(): Void {
        untyped __js__("alert('crash!')");
    }

    private function spawnObstacleIfNecessary(timestamp: Float) {
        var spawnResult = spawner.spawn(timestamp);

        if(spawnResult.spawned) {
            add(spawnResult.gameObject);
        }
    }

    private function updateAllGameObjects(timestamp: Float) {
        for(gameObject in this.gameObjects)
            gameObject.update(timestamp);
    }

    private function add(gameObject: GameObject): Void {
        this.keyboard.subscribe(gameObject.getKeyboardObserver());

        var compositeShape = gameObject.getShape();
        for(shape in compositeShape)
            this.board.add(shape);

        var compositeCollider = gameObject.getCollider();
        for(collider in compositeCollider)
            this.collisionResolver.addToCollisionGroup(gameObject.getCollisionGroupName(), collider, gameObject.notifyAboutCollisions ? this : null);

        this.gameObjects.push(gameObject);
    }

    private function removeDisposedGameObjects() {
        this.gameObjects = [for(gameObject in this.gameObjects) if(!gameObject.disposed) gameObject];
    }
}
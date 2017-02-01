package game;

import engine.graphics.drawing.shapes.Shape;
import engine.graphics.drawing.shapes.RectangleShape;
import engine.graphics.drawing.Color;

import engine.math.Vec2;
import engine.math.Vec3;

import engine.collisions.Collider;

import game.Main;

class ObstacleSpawner {
    private var lastSpawnedTime: Float;

    public function new() {
        this.lastSpawnedTime = 0;
    }

    public function spawn(timestamp: Float): SpawnResult {
        if(timestamp - this.lastSpawnedTime > GamePlayParameters.WALL_SPAWN_INTERVAL) {
            this.lastSpawnedTime = timestamp;
            return new SpawnResult(new Obstacle(GamePlayParameters.GAME_WIDTH, GamePlayParameters.GAME_HEIGHT, GamePlayParameters.WALL_WIDTH, GamePlayParameters.WALL_GAP_SIZE, GamePlayParameters.WALL_HEIGHT_MIN));
        }
        return new SpawnResult();
    }
}

class SpawnResult {
    public var spawned(default, null): Bool;
    public var gameObject(default, null): GameObject;

    public function new(gameObject: GameObject = null) {
        this.spawned = gameObject != null;
        this.gameObject = gameObject;
    }
}

private class Obstacle extends GameObject {
    private var speed: Vec2;
    private var compositeShape: Array<Shape>;
    private var compositeCollider: Array<Collider>;
    private var position: Vec2;
    private var width: Int;

    public function new(positionX: Int, height: Int, width: Int, gapSize: Int, heightMin: Int) {
        super();
        this.width = width;
        this.compositeShape = new Array<Shape>();
        this.compositeCollider = new Array<Collider>();   
        this.speed = new Vec2(-1, 0);
        this.position = new Vec2(positionX, 0);
        generateWallParts(positionX, height, gapSize, heightMin);
    }

    public override function update(timestamp: Float) {
        disposeIfNecessary();
        move();
    }

    public override function getShape(): Array<Shape> {
        return this.compositeShape;
    }

    override public function getCollider(): Array<Collider> {
        return this.compositeCollider;
    }

    private function generateWallParts(positionX: Int, height: Int, gapSize: Int, heightMin: Int) {
        var wholeWallHeight = height - gapSize;

        /*
            get random height for first part of the wall,
            that ensures none of the two parts of the wall are shorter than min height
        */
        var upperPartHeight = Std.random(wholeWallHeight - 2*heightMin) + heightMin;
        var lowerPartHeight = wholeWallHeight - upperPartHeight;

        this.compositeShape.push(new RectangleShape(new Vec2(positionX, 0), this.width, upperPartHeight, GamePlayParameters.WALL_COLOR));
        this.compositeShape.push(new RectangleShape(new Vec2(positionX, height - lowerPartHeight), this.width, lowerPartHeight, GamePlayParameters.WALL_COLOR));

        this.compositeCollider.push(new Collider(new Vec2(positionX, 0), this.width, upperPartHeight));
        this.compositeCollider.push(new Collider(new Vec2(positionX, height - lowerPartHeight), this.width, lowerPartHeight));
    }

    private function move(): Void {
        for(shape in compositeShape)
            shape.move(this.speed);

        for(collider in compositeCollider)
            collider.move(this.speed);

        this.position = this.position.add(this.speed);
    }

    private function disposeIfNecessary() {
        if(isOutOfTheScreen())
            this.disposed = true;
    }

    private function isOutOfTheScreen() {
        return this.position.x + this.width < 0;
    }
}
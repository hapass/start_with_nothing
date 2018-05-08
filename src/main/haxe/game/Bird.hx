package game;

import engine.math.Vec2;

import engine.graphics.drawing.shapes.RectangleShape;
import engine.graphics.drawing.shapes.Shape;

import engine.input.KeyboardState;
import engine.input.Key;
import engine.input.KeyboardObserver;

import engine.collisions.Collider;

import lang.Promise;

class Bird extends GameObject implements KeyboardObserver {
    private static inline var BIRD_COLLISION_GROUP_NAME:String = "Bird";

    private var shape:Shape;
    private var collider:Array<Collider>;
    private var currentSpeed:Vec2;
    private var acceleration:Vec2;
    private var position:Vec2;

    private var lifetimeObservers:Array<BirdLifetimeObserver>;

    public function subscribe(observer:BirdLifetimeObserver) {
        this.lifetimeObservers.push(observer);
    }

    private function new() {
        super();
        this.currentSpeed = new Vec2(0, 0);
        this.acceleration = new Vec2(0, GamePlayParameters.BIRD_FALL_ACCELERATION);
        this.lifetimeObservers = new Array<BirdLifetimeObserver>();
    }

    public static function create():Promise<Bird> {
        var promise = new Promise<Bird>();
        var bird = new Bird();

        bird.position = new Vec2(GamePlayParameters.BIRD_LEFT_DISTANCE, GamePlayParameters.BIRD_UP_DISTANCE);
        bird.collider = [new Collider(bird.position, GamePlayParameters.BIRD_WIDTH, GamePlayParameters.BIRD_HEIGHT)];

        new RectangleShape(bird.position, GamePlayParameters.BIRD_WIDTH, GamePlayParameters.BIRD_HEIGHT)
            .setImageUrl("bird.jpg").then(function(shape:Shape) {
                bird.shape = shape;
                promise.resolve(bird);
            });

        return promise;
    }

    override public function update(timestamp:Float) {
        applyGravity();
        move();

        if(isOutOfScreen()) {
            for(observer in lifetimeObservers) {
                observer.onBirdDeath();
            }
        }
    }

    override public function getKeyboardObserver() {
        return this;
    }

    override public function getCollider():Array<Collider> {
        return this.collider;
    }

    override public function getShape():Array<Shape> {
        var array:Array<Shape> = new Array<Shape>();
        if(this.shape != null) {
            array.push(this.shape);
        }
        return array;
    }

    override public function getCollisionGroupName():String {
        return BIRD_COLLISION_GROUP_NAME;
    }

    public function onInput(state:KeyboardState):Void {
        if(state.hasBeenPressed(Key.SPACE)) {
            fly();
        }
    }

    private function fly() {
        this.currentSpeed = new Vec2(0, -GamePlayParameters.BIRD_FLIGHT_ACCELERATION);
    }

    private function applyGravity() {
        this.currentSpeed = this.currentSpeed.add(this.acceleration);
    }

    private function move() {
        this.position = this.position.add(this.currentSpeed);
        this.shape.move(this.currentSpeed);
        this.collider[0].move(this.currentSpeed);
    }

    private function isOutOfScreen() {
        return this.position.x > GamePlayParameters.GAME_WIDTH ||
            this.position.x < 0 ||
            this.position.y > GamePlayParameters.GAME_HEIGHT ||
            this.position.y < 0;
    }
}
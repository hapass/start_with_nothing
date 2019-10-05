package game;

import engine.math.Vec2;

import engine.graphics.drawing.shapes.RectangleShape;
import engine.graphics.drawing.shapes.Shape;
import engine.graphics.drawing.Color;

import engine.input.KeyboardState;
import engine.input.Key;
import engine.input.KeyboardObserver;

import engine.collisions.Collider;

import lang.Promise;

class Glow extends GameObject implements KeyboardObserver {
    private static inline var GLOW_COLLISION_GROUP_NAME:String = "Glow";

    private var shape:Shape;
    private var collider:Array<Collider>;
    private var currentSpeed:Vec2;
    private var acceleration:Vec2;
    private var position:Vec2;

    private var lifetimeObservers:Array<GlowLifetimeObserver>;

    public function subscribe(observer:GlowLifetimeObserver) {
        this.lifetimeObservers.push(observer);
    }

    private function new() {
        super();
        this.currentSpeed = new Vec2(0, 0);
        this.acceleration = new Vec2(0, GamePlayParameters.GLOW_FALL_ACCELERATION);
        this.lifetimeObservers = new Array<GlowLifetimeObserver>();
    }

    public static function create():Glow {
        var glow = new Glow();

        glow.position = new Vec2(GamePlayParameters.GLOW_LEFT_DISTANCE, GamePlayParameters.GLOW_UP_DISTANCE);
        glow.collider = [new Collider(glow.position, GamePlayParameters.GLOW_WIDTH, GamePlayParameters.GLOW_HEIGHT)];
        glow.shape = new RectangleShape(glow.position, GamePlayParameters.GLOW_WIDTH, GamePlayParameters.GLOW_HEIGHT).setColor(Color.BLUE);

        return glow;
    }

    override public function update(timestamp:Float) {
        applyGravity();
        move();

        if(isOutOfScreen()) {
            for(observer in lifetimeObservers) {
                observer.onGlowDeath();
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
        return GLOW_COLLISION_GROUP_NAME;
    }

    public function onInput(state:KeyboardState):Void {
        if(state.hasBeenPressed(Key.SPACE)) {
            fly();
        }
    }

    private function fly() {
        this.currentSpeed = new Vec2(0, -GamePlayParameters.GLOW_FLIGHT_ACCELERATION);
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
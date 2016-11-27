package game;

import engine.math.Vec2;
import engine.math.Vec3;

import engine.graphics.drawing.DrawingBoard;
import engine.graphics.drawing.Color;
import engine.graphics.drawing.shapes.Rectangle;

import engine.loop.GameLoop;
import engine.loop.GameLoopObserver;

import engine.input.Key;
import engine.input.Keyboard;

class Main {
    static function main() {
        var game = new Game();
        game.start();
    }
}

class Game implements GameLoopObserver {
    private var loop: GameLoop;
    private var input: Keyboard;
    private var board: DrawingBoard;
    private var bird: Rectangle;

    public function new() {
        this.input = new Keyboard([Key.SPACE]);
        this.loop = new GameLoop();
        this.loop.subscribe(this);
        this.board = new DrawingBoard(800, 600);
    }

    public function start() {
        this.bird = new Rectangle(new Vec2(0, 0), 10, 10, Color.YELLOW);
        this.board.add(bird);
        this.loop.start();
    }

    public function update(timestamp: Float) {
        if(input.isKeyDown(Key.SPACE))
            this.bird.move(new Vec2(1, 0));
        
        if(input.hasBeenPressed(Key.SPACE))
            this.bird.move(new Vec2(200, 0));

        this.board.draw();
    }
}
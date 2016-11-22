package game;

import engine.math.Vec2;
import engine.math.Vec3;

import engine.graphics.drawing.DrawingBoard;
import engine.graphics.drawing.Color;
import engine.graphics.drawing.shapes.Rectangle;

import engine.loop.GameLoop;
import engine.loop.GameLoopObserver;

class Main {
    static function main() {
        var game = new Game();
        game.start();
    }
}

class Game implements GameLoopObserver {
    private var loop: GameLoop;
    private var board: DrawingBoard;
    private var bird: Rectangle;

    public function new() {
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
        this.bird.move(new Vec2(1, 0));
        this.board.draw();
    }
}
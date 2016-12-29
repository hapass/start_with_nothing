package game;

import engine.graphics.drawing.DrawingBoard;

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
    private var gameObjects: Array<GameObject>;

    public function new() {
        this.input = new Keyboard([Key.SPACE]);
        this.board = new DrawingBoard(800, 600);
        this.gameObjects = new Array<GameObject>();
        this.loop = new GameLoop();
    }

    public function start() {
        var bird: GameObject = new Bird();

        this.input.subscribe(bird.getKeyboardObserver());
        this.board.add(bird.getShape());

        this.gameObjects.push(bird);

        this.loop.subscribe(this);
        this.loop.start();
    }

    public function update(timestamp: Float) {
        this.input.checkInput();

        for(gameObject in this.gameObjects)
            gameObject.update(timestamp);

        this.board.draw();
    }
}
package game;

import engine.Debug;
import game.Level;
import engine.Renderer;
import engine.GameLoop;
import engine.Vec2;
import engine.Keyboard;
import engine.Promise;
import js.Browser;

enum GameResult {
    Win;
    Fail;
}

class Main {
    static function main() {
        launch();
    }

    public static function launch() {
        new Game().run().then(function(result:GameResult) {
            switch(result) {
                case GameResult.Fail:
                    Browser.alert("You've lost. Try again!");
                    launch();
                case GameResult.Win:
                    Browser.alert("You won!");
            }
        });
    }
}

class Game {
    private var animatingGlow:Bool = false;
    private var glowRadiusSpeed:Float = 0.0;

    private var loop:GameLoop = new GameLoop();
    private var keyboard:Keyboard = new Keyboard([Key.SPACE, Key.RIGHT, Key.LEFT, Key.SHIFT]);
    private var renderer:Renderer = new Renderer(Config.GAME_WIDTH, Config.GAME_HEIGHT);

    private var glow:Glow = new Glow();
    private var level:Level = new Level();
    private var gameResult:Promise<GameResult> = new Promise<GameResult>();

    private var bottomIntersectionOffset:Vec2 = new Vec2();

    public function new() {}

    public function run():Promise<GameResult> {
        this.glow.position.set(this.level.glowPosition.x, this.level.glowPosition.y);
        this.glow.light.position.set(this.glow.position.x + Config.TILE_SIZE / 2, this.glow.position.y + Config.TILE_SIZE / 2);
        this.renderer.add([glow.shape]);
        this.renderer.setLight(glow.light);
        this.renderer.add(this.level.compositeShape);
        this.loop.start(this.update);
        return this.gameResult;
    }

    public function update(timestamp:Float):Void {
        this.keyboard.update();
        this.glow.update(this.level);

        var result:TileType = level.getTileType(
            Math.floor((this.glow.position.y + Config.TILE_SIZE / 2) / Config.TILE_SIZE),
            Math.floor((this.glow.position.x + Config.TILE_SIZE / 2) / Config.TILE_SIZE)
        );

        if (result == None) {
            stop(GameResult.Fail);
            return;
        }

        if (result == Exit) {
            stop(GameResult.Win);
            return;
        }

        this.renderer.draw();
    }

    private function stop(result:GameResult) {
        this.loop.stop();
        this.renderer.dispose();
        this.keyboard.dispose();
        this.gameResult.resolve(result);
    }
}
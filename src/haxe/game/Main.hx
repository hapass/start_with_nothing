package game;

import game.Level;
import engine.Vec2;
import engine.Renderer;
import engine.GameLoop;
import engine.Keyboard;
import engine.Audio;
import engine.Key;
import engine.Promise;
import js.Browser;

enum GameResult {
    Win;
    Fail;
    NextLevel;
}

class Main {
    static function main() {
        var levels:Array<Level> = LevelFactory.createLevels();
        launch(levels, 0);
    }

    public static function launch(levels:Array<Level>, currentLevel:Int) {
        Browser.document.getElementById("play").classList.remove("hide");
        new Game().run(levels, currentLevel).then(function(result:GameResult) {
            switch(result) {
                case GameResult.NextLevel:
                    Browser.alert("Level complete!");
                    launch(levels, ++currentLevel);
                case GameResult.Fail:
                    Browser.alert("You've lost. Try again!");
                    launch(levels, currentLevel);
                case GameResult.Win:
                    Browser.alert("You won!");
            }
        });
    }
}

class Game {
    private var keyboard:Keyboard = new Keyboard([Key.SPACE, Key.RIGHT, Key.LEFT, Key.SHIFT]);
    private var loop:GameLoop = new GameLoop();
    private var renderer:Renderer = new Renderer(Config.GAME_WIDTH, Config.GAME_HEIGHT);

    private var audio:Audio;
    private var level:Level;
    private var glow:Glow;
    private var gameResult:Promise<GameResult> = new Promise<GameResult>();

    public function new() {}

    public function run(levels:Array<Level>, currentLevel:Int):Promise<GameResult> {
        if (currentLevel == levels.length) {
            this.gameResult.resolve(GameResult.Win);
            return this.gameResult;
        }

        this.keyboard.onceOnUserInput = ()->{
            this.level = levels[currentLevel];
            this.audio = new Audio();
            this.glow = new Glow(new Vec2(this.level.spawn.x, this.level.spawn.y), audio);
            this.renderer.add([this.glow.shape]);
            this.renderer.setLight(this.glow.light);
            this.renderer.add(this.level.shape);
            this.loop.start(this.update);
            Browser.document.getElementById("play").classList.add("hide");
        };

        return this.gameResult;
    }

    public function update(tickTime:Float):Void {
        this.keyboard.update();
        this.glow.update(this.level, tickTime);

        var result:TileType = level.getTileType(
            Math.floor((this.glow.position.y + Config.TILE_SIZE / 2) / Config.TILE_SIZE),
            Math.floor((this.glow.position.x + Config.TILE_SIZE / 2) / Config.TILE_SIZE)
        );

        if (result == None) {
            stop(GameResult.Fail);
            return;
        }

        if (result == Exit) {
            stop(GameResult.NextLevel);
            return;
        }

        this.renderer.draw();
        this.audio.update();
    }

    private function stop(result:GameResult) {
        this.loop.stop();
        this.audio.dispose();
        this.renderer.dispose();
        this.keyboard.dispose();
        this.gameResult.resolve(result);
    }
}
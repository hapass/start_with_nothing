package game;

import game.Level;
import engine.Renderer;
import engine.GameLoop;
import engine.Keyboard;
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
    private var loop:GameLoop = new GameLoop();
    private var keyboard:Keyboard = new Keyboard([Key.SPACE, Key.RIGHT, Key.LEFT, Key.SHIFT]);
    private var renderer:Renderer = new Renderer(Config.GAME_WIDTH, Config.GAME_HEIGHT);

    private var level:Level;
    private var gameResult:Promise<GameResult> = new Promise<GameResult>();

    public function new() {}

    public function run(levels:Array<Level>, currentLevel:Int):Promise<GameResult> {
        if (currentLevel == levels.length) {
            this.gameResult.resolve(GameResult.Win);
            return this.gameResult;
        }

        this.level = levels[currentLevel];
        this.renderer.add([this.level.glow.shape]);
        this.renderer.setLight(this.level.glow.light);
        this.renderer.add(this.level.shape);
        this.loop.start(this.update);

        return this.gameResult;
    }

    public function update(timestamp:Float):Void {
        this.keyboard.update();
        this.level.glow.update(this.level);

        var result:TileType = level.getTileType(
            Math.floor((this.level.glow.position.y + Config.TILE_SIZE / 2) / Config.TILE_SIZE),
            Math.floor((this.level.glow.position.x + Config.TILE_SIZE / 2) / Config.TILE_SIZE)
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
    }

    private function stop(result:GameResult) {
        this.loop.stop();
        this.renderer.dispose();
        this.keyboard.dispose();
        this.gameResult.resolve(result);
    }
}
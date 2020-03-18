package game;

import engine.Color;
#if macro
import sys.io.File;
import sys.FileSystem;
import haxe.macro.Expr;
import haxe.macro.Context;
import game.Level;
import engine.Debug;
import engine.Quad;
import engine.Vec2;

using StringTools;
#end

class LevelFactory {
    public static macro function createLevels() {
        var fileNames = FileSystem.readDirectory('data');
        var levels = new Array<Level>();
        for (fileName in fileNames) {
            var glow;
            var shape = new Array<Quad>();
            var data = new Array<Array<Int>>();

            var stringData = File.getContent('data/${fileName}').replace("\n", "").replace(" ", "");
            for (row in 0...Config.GAME_HEIGHT_TILES) {
                data.push(new Array<Int>());
                for (column in 0...Config.GAME_WIDTH_TILES) {
                    var char = stringData.charAt(row * Config.GAME_WIDTH_TILES + column);
                    Debug.assert(char != "", 'Incorrect level format. Could not get character at: [$row, $column]');
                    var elementId = Std.parseInt(char);
                    Debug.assert(elementId != null, 'Incorrect level format. Could not parse character at: [$row, $column]');
                    data[row].push(elementId);
                }
            }

            for (rowIndex in 0...data.length) {
                for (columnIndex in 0...data[rowIndex].length) {
                    var positionX = columnIndex * Config.TILE_SIZE;
                    var positionY = rowIndex * Config.TILE_SIZE;
    
                    if (data[rowIndex][columnIndex] == Wall) {
                        shape.push(new Quad(Config.WALL_COLOR, Config.TILE_SIZE, new Vec2(positionX, positionY)));
                    }
    
                    if (data[rowIndex][columnIndex] == Exit) {
                        shape.push(new Quad(Config.EXIT_COLOR, Config.TILE_SIZE, new Vec2(positionX, positionY)));
                    }
    
                    if (data[rowIndex][columnIndex] == Spawn) {
                        glow = new Glow(new Vec2(positionX, positionY));
                    }
                }
            }

            levels.push(new Level(shape, data, glow));
        }
        

        /**
            [
                new Level(
                    [
                        new Quad(
                            Config.WALL_COLOR, 
                            Config.TILE_SIZE, 
                            new Vec2(float, float)
                        )
                    ], 
                    [
                        [float, float],
                        [float, float]
                    ],
                    new Glow(new Vec2(float, float))
                ),
                new Level(
                    [
                        new Quad(
                            Config.WALL_COLOR, 
                            Config.TILE_SIZE, 
                            new Vec2(float, float)
                        )
                    ], 
                    [
                        [float, float],
                        [float, float]
                    ],
                    new Glow(new Vec2(float, float))
                )
            ]
        **/
        var levelExpressions:Array<Expr> = new Array<Expr>();
        for (level in levels) {

            var quadExpressions:Array<Expr> = new Array<Expr>();
            for (quad in level.shape) {
                var quadPositionExpression:Expr = macro new engine.Vec2($v{quad.position.x}, $v{quad.position.y});
                var colorExpression:Expr = 
                    if(quad.color == Config.EXIT_COLOR) macro $p{["game", "Config", "EXIT_COLOR"]};
                    else macro $p{["game", "Config", "WALL_COLOR"]};
                quadExpressions.push(macro new engine.Quad($e{colorExpression}, $v{Config.TILE_SIZE}, $e{quadPositionExpression}));
            }

            var columnExpressions:Array<Expr> = new Array<Expr>();
            for (column in level.data) {
                var valueListExpression = [for (value in column) macro $v{value}];
                columnExpressions.push(macro $a{valueListExpression});
            }

            var glowPositionExpression:Expr = macro new engine.Vec2($v{level.glow.position.x}, $v{level.glow.position.y});
            var glowExpression:Expr = macro new game.Glow($e{glowPositionExpression});

            levelExpressions.push(macro new game.Level($a{quadExpressions}, $a{columnExpressions}, $e{glowExpression}));
        }

        return macro $a{levelExpressions};
    }


}
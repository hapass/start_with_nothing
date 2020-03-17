package game;

import engine.Quad;
import engine.Vec2;
import engine.Debug;

#if macro
import sys.io.File;
import haxe.macro.Expr;
import haxe.macro.Context;
#end

using StringTools;

class Level {
    public var compositeShape:Array<Quad> = new Array<Quad>();
    public var data:Array<Array<Int>> = new Array<Array<Int>>();
    public var glowPosition:Vec2 = new Vec2();

    public function new() {
        this.data = createLevel("BlindLuck.lvl");

        for (rowIndex in 0...data.length) {
            for (columnIndex in 0...data[rowIndex].length) {
                var positionX = columnIndex * Config.TILE_SIZE;
                var positionY = rowIndex * Config.TILE_SIZE;

                if (data[rowIndex][columnIndex] == 1 || data[rowIndex][columnIndex] == 2) {
                    var rect = new Quad();
                    rect.position.set(positionX, positionY);
                    rect.width = Config.TILE_SIZE;
                    rect.height = Config.TILE_SIZE;

                    if (data[rowIndex][columnIndex] == 1) {
                        rect.color = Config.LEVEL_COLOR;
                    }

                    if (data[rowIndex][columnIndex] == 2) {
                        rect.color = Config.EXIT_COLOR;
                    }

                    compositeShape.push(rect);
                }

                if (data[rowIndex][columnIndex] == 3) {
                    glowPosition.set(columnIndex * Config.TILE_SIZE, rowIndex * Config.TILE_SIZE);
                }
            }
        }
    }

    public static macro function createLevel(level:Expr) {
        var fileName = switch (level.expr) {
            case EConst(CString(value)): value;
            default: "";
        }

        var data:Array<Array<Int>> = new Array<Array<Int>>();

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

        var columnExpressions:Array<Expr> = [];
        for (column in data) {
            var valueListExpression = [for (value in column) macro $v{value}];
            columnExpressions.push(macro $a{valueListExpression});
        }
        return macro $a{columnExpressions};
    }

    private function isCellValid(row:Int, column:Int):Bool {
        return 
            0 <= row && row < this.data.length && 
            0 <= column && column < this.data[row].length;
    }

    public function getIntersection(row:Int, column:Int):Int {
        if (!isCellValid(row, column)) {
            return -1;
        }

        if (data[row][column] == 2) {
            return 2;
        }

        if (data[row][column] == 1) {
            return 1;
        }

        return 0;
    }
}
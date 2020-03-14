package game;

import engine.graphics.Quad;
import engine.math.Vec2;

#if macro
import sys.io.File;
import haxe.macro.Expr;
import haxe.macro.Context;
import lang.Debug;

using StringTools;
#end

class Level {
    public var compositeShape:Array<Quad> = new Array<Quad>();
    public var data:Array<Array<Int>> = new Array<Array<Int>>();
    public var glowPosition:Vec2<Float> = new Vec2Float();

    public function new() {
        var stringData = createLevel("BlindLuck.lvl");

        for (rowIndex in 0...data.length) {
            for (columnIndex in 0...data[rowIndex].length) {
                var positionX = columnIndex * Config.BRUSH_WIDTH;
                var positionY = rowIndex * Config.BRUSH_HEIGHT;

                if (data[rowIndex][columnIndex] == 1 || data[rowIndex][columnIndex] == 2) {
                    var rect = new Quad();
                    rect.position.set(positionX, positionY);
                    rect.width = Config.BRUSH_WIDTH;
                    rect.height = Config.BRUSH_HEIGHT;

                    if (data[rowIndex][columnIndex] == 1) {
                        rect.color = Config.BRUSH_COLOR;
                    }

                    if (data[rowIndex][columnIndex] == 2) {
                        rect.color = Config.EXIT_COLOR;
                    }

                    compositeShape.push(rect);
                }

                if (data[rowIndex][columnIndex] == 3) {
                    glowPosition.set(columnIndex * Config.BRUSH_WIDTH, rowIndex * Config.BRUSH_HEIGHT);
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
        for (row in 0...Config.GAME_HEIGHT_BRUSHES) {
            data.push(new Array<Int>());
            for (column in 0...Config.GAME_WIDTH_BRUSHES) {
                var char = stringData.charAt(row * Config.GAME_WIDTH_BRUSHES + column);
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

    public function isCellValid(cell:Vec2<Int>):Bool {
        return 
            0 <= cell.y && cell.y < this.data.length && 
            0 <= cell.x && cell.x < this.data[cell.y].length;
    }

    public function getCellType(cell:Vec2<Int>):Int {
        return data[cell.y][cell.x];
    }
}
package game;

import engine.graphics.Renderer;
import engine.math.Vec2;
import engine.data.Data;
import lang.Debug;

class Level {
    public var compositeShape:Array<Quad>;
    public var data:Array<Array<Int>>;
    public var glowPosition:Vec2;

    public function new() {
        this.compositeShape = new Array<Quad>();
        this.glowPosition = new Vec2(0, 0);

        var stringData = Data.getString("BlindLuck");

        this.data = new Array<Array<Int>>();
        for (row in 0...Config.GAME_HEIGHT_BRUSHES) {
            this.data.push(new Array<Int>());
            for (column in 0...Config.GAME_WIDTH_BRUSHES) {
                var char = stringData.charAt(row * Config.GAME_WIDTH_BRUSHES + column);
                Debug.assert(char != "", 'Incorrect level format. Could not get character at: [$row, $column]');
                var elementId = Std.parseInt(char);
                Debug.assert(elementId != null, 'Incorrect level format. Could not parse character at: [$row, $column]');
                this.data[row].push(elementId);
            }
        }

        for (rowIndex in 0...this.data.length) {
            for (columnIndex in 0...this.data[rowIndex].length) {
                var positionX = columnIndex * Config.BRUSH_WIDTH;
                var positionY = rowIndex * Config.BRUSH_HEIGHT;

                if (this.data[rowIndex][columnIndex] == 1 || this.data[rowIndex][columnIndex] == 2) {
                    var rect = new Quad();
                    rect.position.set(positionX, positionY);
                    rect.width = Config.BRUSH_WIDTH;
                    rect.height = Config.BRUSH_HEIGHT;

                    if (this.data[rowIndex][columnIndex] == 1) {
                        rect.color = Config.BRUSH_COLOR;
                    }

                    if (this.data[rowIndex][columnIndex] == 2) {
                        rect.color = Config.EXIT_COLOR;
                    }

                    this.compositeShape.push(rect);
                }

                if (this.data[rowIndex][columnIndex] == 3) {
                    this.glowPosition.set(columnIndex * Config.BRUSH_WIDTH, rowIndex * Config.BRUSH_HEIGHT);
                }
            }
        }
    }
}
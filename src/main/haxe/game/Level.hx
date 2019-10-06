package game;

import engine.graphics.drawing.shapes.Shape;
import engine.graphics.drawing.shapes.RectangleShape;
import engine.math.Vec2;
import engine.data.Data;
import lang.Debug;

class Level {
    public var compositeShape:Array<Shape>;
    public var position:Vec2;

    public function new() {
        this.compositeShape = new Array<Shape>();
        this.position = new Vec2(0, 0);

        var stringData = new Data("BlindLuck").stringData;

        var data = new Array<Array<Int>>();
        for (row in 0...Config.GAME_HEIGHT_BRUSHES)
        {
            data.push(new Array<Int>());
            for (column in 0...Config.GAME_WIDTH_BRUSHES)
            {
                var char = stringData.charAt(row * Config.GAME_WIDTH_BRUSHES + column);
                Debug.assert(char != "", 'Incorrect level format. Could not get character at: [$row, $column]');
                var elementId = Std.parseInt(char);
                Debug.assert(elementId != null, 'Incorrect level format. Could not parse character at: [$row, $column]');
                data[row].push(elementId);
            }
        }

        for (rowIndex in 0...data.length)
        {
            for (columnIndex in 0...data[rowIndex].length)
            {
                var positionX = this.position.x + columnIndex * Config.BRUSH_WIDTH;
                var positionY = this.position.y + rowIndex * Config.BRUSH_HEIGHT;

                if (data[rowIndex][columnIndex] == 1)
                {
                    trace('Spawned brush at: [$positionX, $positionY] in pixels; [$columnIndex, $rowIndex] in brushes.');
                    this.compositeShape.push(
                        new RectangleShape(new Vec2(positionX, positionY), Config.BRUSH_WIDTH, Config.BRUSH_HEIGHT)
                        .setColor(Config.BRUSH_COLOR)
                    );
                }
            }
        }
    }
}
package game;

import engine.graphics.drawing.shapes.Shape;
import engine.graphics.drawing.shapes.RectangleShape;
import engine.math.Vec2;
import engine.data.Data;

import lang.Debug;

class LevelSpawner {
    private var lastSpawnedTime: Float;
    private var data: Array<Array<Int>>;

    public function new() {
        var stringData = new Data("BlindLuck").stringData;

        this.data = new Array<Array<Int>>();
        for (row in 0...GamePlayParameters.GAME_HEIGHT_BRUSHES)
        {
            this.data.push(new Array<Int>());
            for (column in 0...GamePlayParameters.GAME_WIDTH_BRUSHES)
            {
                var char = stringData.charAt(row * GamePlayParameters.GAME_WIDTH_BRUSHES + column);
                Debug.assert(char != "", 'Incorrect level format. Could not get character at: [$row, $column]');
                var elementId = Std.parseInt(char);
                Debug.assert(elementId != null, 'Incorrect level format. Could not parse character at: [$row, $column]');
                data[row].push(elementId);
            }
        }
    }

    public function spawn(): SpawnResult {
        return new SpawnResult(new Level(this.data));
    }
}

class SpawnResult {
    public var spawned(default, null): Bool;
    public var gameObject(default, null): GameObject;

    public function new(gameObject: GameObject = null) {
        this.spawned = gameObject != null;
        this.gameObject = gameObject;
    }
}

private class Level extends GameObject {
    private var compositeShape: Array<Shape>;
    private var position: Vec2;

    public function new(data: Array<Array<Int>>) {
        super();
        this.compositeShape = new Array<Shape>();
        this.position = new Vec2(0, 0);

        for (rowIndex in 0...data.length)
        {
            for (columnIndex in 0...data[rowIndex].length)
            {
                var positionX = this.position.x + columnIndex * GamePlayParameters.BRUSH_WIDTH;
                var positionY = this.position.y + rowIndex * GamePlayParameters.BRUSH_HEIGHT;

                if (data[rowIndex][columnIndex] == 1)
                {
                    trace('Spawned brush at: [$positionX, $positionY] in pixels; [$columnIndex, $rowIndex] in brushes.');
                    this.compositeShape.push(
                        new RectangleShape(new Vec2(positionX, positionY), GamePlayParameters.BRUSH_WIDTH, GamePlayParameters.BRUSH_HEIGHT)
                        .setColor(GamePlayParameters.BRUSH_COLOR)
                    );
                }
            }
        }
    }

    public override function getShape(): Array<Shape> {
        return this.compositeShape;
    }
}
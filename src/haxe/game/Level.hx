package game;

import engine.Quad;
import engine.Vec2;

enum abstract TileType(Int) from Int to Int {
    var None = -1;
    var Empty = 0;
    var Wall = 1;
    var Exit = 2;
    var Spawn = 3;
}

class Level {
    public var shape:Array<Quad>;
    public var data:Array<Array<Int>>;
    public var spawn:Vec2;

    public function new(shape:Array<Quad>, data:Array<Array<Int>>, spawn:Vec2) {
        this.shape = shape;
        this.data = data;
        this.spawn = spawn;
    }

    public function getTileType(row:Int, column:Int):TileType {
        if (0 <= row && row < this.data.length && 0 <= column && column < this.data[row].length) {
            return data[row][column];
        }

        return None;
    }
}
package drawing.shapes;

import drawing.utils.Vec2;
import drawing.utils.Color;
import js.html.Float32Array;

class Triangle {

    public static inline var VERTICES_NUMBER = 3;
    
    public var ver1: Vec2;
    public var ver2: Vec2;
    public var ver3: Vec2;
    public var color: Color;

    public function new(ver1: Vec2, ver2: Vec2, ver3: Vec2, color: Color){
        this.ver1 = ver1;
        this.ver2 = ver2;
        this.ver3 = ver3;
        this.color = color;
    }

    public function move(vec: Vec2) {
        this.ver1 = this.ver1.add(vec);
        this.ver2 = this.ver2.add(vec);
        this.ver3 = this.ver3.add(vec);
    }

    public function getVertices(): Float32Array {
        var positions = [this.ver1.x, this.ver1.y,
            this.ver2.x, this.ver2.y,
            this.ver3.x, this.ver3.y];
        return new Float32Array(positions);
    }
}
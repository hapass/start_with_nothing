package engine.collisions;

import engine.math.Vec2;

@:allow(engine.collisions.Collider)
class Collider {
    private var position: Vec2;
    private var width: Float;
    private var height: Float;

    public function new(position: Vec2, width: Float, height: Float) {
        this.position = position;
        this.width = width;
        this.height = height;
    }

    public function move(vec: Vec2): Void {
        this.position = this.position.add(vec);
    }

    public function intersects(collider: Collider): Bool {
        return this.position.x < collider.position.x + collider.width &&
               this.position.x + this.width > collider.position.x &&
               this.position.y < collider.position.y + collider.height &&
               this.position.y + this.height > collider.position.y;
    }
}
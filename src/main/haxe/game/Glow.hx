package game;

import engine.math.Vec2;

import engine.graphics.drawing.shapes.RectangleShape;
import engine.graphics.drawing.shapes.Shape;
import engine.graphics.drawing.Color;

class Glow {
    public var shape:Shape;
    public var currentSpeed:Vec2;
    public var acceleration:Vec2;
    public var position:Vec2;

    public var isTopIntersecting:Bool;
    public var isBottomIntersecting:Bool;
    public var isLeftIntersecting:Bool;
    public var isRightIntersecting:Bool;

    public function new(pos: Vec2) {
        this.currentSpeed = new Vec2(0, 0);
        this.acceleration = new Vec2(0, Config.GLOW_FALL_ACCELERATION);
        this.position = pos;
        this.shape = new RectangleShape(this.position, Config.GLOW_WIDTH, Config.GLOW_HEIGHT).setColor(Config.GLOW_COLOR);
    }

    public function move(offset: Vec2)
    {
        this.position = this.position.add(offset);
        this.shape.move(offset);
    }

    public var topLeftCorner(get, never):Vec2;
    private function get_topLeftCorner():Vec2
    {
        return position;
    }

    public var topRightCorner(get, never):Vec2;
    private function get_topRightCorner():Vec2
    {
        return new Vec2(position.x + Config.GLOW_WIDTH - 1, position.y);
    }

    public var bottomLeftCorner(get, never):Vec2;
    private function get_bottomLeftCorner():Vec2
    {
        return new Vec2(position.x, position.y + Config.GLOW_HEIGHT);
    }

    public var bottomRightCorner(get, never):Vec2;
    private function get_bottomRightCorner():Vec2
    {
        return new Vec2(position.x + Config.GLOW_WIDTH - 1, position.y + Config.GLOW_HEIGHT);
    }

    public var center(get, never):Vec2;
    private function get_center():Vec2
    {
        return new Vec2(position.x + Std.int(Config.GLOW_WIDTH / 2), position.y + Std.int(Config.GLOW_HEIGHT / 2));
    }
}
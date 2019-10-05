package game;

import engine.graphics.drawing.Color;

class GamePlayParameters {
    public static inline var GAME_WIDTH: Int = 800;
    public static inline var GAME_HEIGHT: Int = 600;

    public static var WALL_COLOR: Color = Color.RED;
    public static inline var WALL_GAP_SIZE: Int = 100;
    public static inline var WALL_WIDTH: Int = 20;
    public static inline var WALL_HEIGHT_MIN: Int = 70;
    public static inline var WALL_SPAWN_INTERVAL: Int = 2500;

    public static var GLOW_COLOR: Color = Color.YELLOW;
    public static inline var GLOW_WIDTH: Int = 20;
    public static inline var GLOW_HEIGHT: Int = 20;
    public static inline var GLOW_UP_DISTANCE: Int = 150;
    public static inline var GLOW_LEFT_DISTANCE: Int = 150;
    public static inline var GLOW_FALL_ACCELERATION: Float = 0.2;
    public static inline var GLOW_FLIGHT_ACCELERATION: Float = 4;
}
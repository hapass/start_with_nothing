package game;

import engine.graphics.drawing.Color;

class GamePlayParameters {
    public static var BRUSH_COLOR: Color = Color.RED;
    public static inline var BRUSH_WIDTH: Int = 20;
    public static inline var BRUSH_HEIGHT: Int = 20;

    public static inline var GAME_WIDTH: Int = 40 * BRUSH_WIDTH;
    public static inline var GAME_HEIGHT: Int = 40 * BRUSH_HEIGHT;

    public static var GLOW_COLOR: Color = Color.YELLOW;
    public static inline var GLOW_WIDTH: Int = 1 * BRUSH_WIDTH;
    public static inline var GLOW_HEIGHT: Int = 1 * BRUSH_HEIGHT;
    
    public static inline var GLOW_UP_DISTANCE: Int = 150;
    public static inline var GLOW_LEFT_DISTANCE: Int = 150;
    public static inline var GLOW_FALL_ACCELERATION: Float = 0.2;
    public static inline var GLOW_FLIGHT_ACCELERATION: Float = 4;
}
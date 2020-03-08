package game;

import engine.graphics.Renderer;

class Config {
    public static var BRUSH_COLOR:Color = Color.RED;
    public static inline var BRUSH_WIDTH:Int = 20;
    public static inline var BRUSH_HEIGHT:Int = 20;

    public static inline var GAME_WIDTH_BRUSHES:Int = 40;
    public static inline var GAME_HEIGHT_BRUSHES:Int = 30;
    public static inline var GAME_WIDTH:Int = GAME_WIDTH_BRUSHES * BRUSH_WIDTH;
    public static inline var GAME_HEIGHT:Int = GAME_HEIGHT_BRUSHES * BRUSH_HEIGHT;

    public static var GLOW_COLOR:Color = Color.WHITE;
    public static inline var GLOW_SPEED:Int = 1;
    public static inline var GLOW_WIDTH_BRUSHES:Int = 1;
    public static inline var GLOW_HEIGHT_BRUSHES:Int = 1;
    public static inline var GLOW_WIDTH:Int = GLOW_WIDTH_BRUSHES * BRUSH_WIDTH;
    public static inline var GLOW_HEIGHT:Int = GLOW_HEIGHT_BRUSHES * BRUSH_HEIGHT;
    
    public static var EXIT_COLOR:Color = Color.YELLOW;

    public static inline var GLOW_FALL_ACCELERATION:Float = 0.2;
    public static inline var GLOW_JUMP_ACCELERATION:Float = -5;
}
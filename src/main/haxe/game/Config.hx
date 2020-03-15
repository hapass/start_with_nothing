package game;

import engine.Color;

@:expose
class Config {
    public static var BRUSH_COLOR:Color = Color.RED;
    public static var BRUSH_WIDTH:Int = 20;
    public static var BRUSH_HEIGHT:Int = 20;

    public static var GAME_WIDTH_BRUSHES:Int = 40;
    public static var GAME_HEIGHT_BRUSHES:Int = 30;
    public static var GAME_WIDTH:Int = GAME_WIDTH_BRUSHES * BRUSH_WIDTH;
    public static var GAME_HEIGHT:Int = GAME_HEIGHT_BRUSHES * BRUSH_HEIGHT;

    public static var GLOW_COLOR:Color = Color.WHITE;
    public static var GLOW_SPEED:Int = 1;
    public static var GLOW_WIDTH_BRUSHES:Int = 1;
    public static var GLOW_HEIGHT_BRUSHES:Int = 1;
    public static var GLOW_WIDTH:Int = GLOW_WIDTH_BRUSHES * BRUSH_WIDTH;
    public static var GLOW_HEIGHT:Int = GLOW_HEIGHT_BRUSHES * BRUSH_HEIGHT;
    public static var GLOW_LIGHT_MIN_RADIUS:Float = 0.015;
    public static var GLOW_LIGHT_MAX_RADIUS:Float = 0.2;
    public static var GLOW_LIGHT_STARTING_SPEED:Float = 0.0008;
    public static var GLOW_LIGHT_ACCELERATION:Float = 0.0007;
    
    public static var EXIT_COLOR:Color = Color.YELLOW;

    public static var GLOW_FALL_ACCELERATION:Float = 1;
    public static var GLOW_JUMP_ACCELERATION:Float = -15;
}
package game;

import engine.Color;

@:expose
class Config {
    public static var TILE_SIZE:Int = 20;
    public static var JUMP_COUNT:Int = 2;

    public static var GAME_WIDTH_TILES:Int = 40;
    public static var GAME_HEIGHT_TILES:Int = 30;
    public static var GAME_WIDTH:Int = GAME_WIDTH_TILES * TILE_SIZE;
    public static var GAME_HEIGHT:Int = GAME_HEIGHT_TILES * TILE_SIZE;

    public static var GLOW_COLOR:Color = Color.WHITE;
    public static var GLOW_MIN_SPEED:Float = 0.2;
    public static var GLOW_MAX_SPEED:Float = 2;
    public static var GLOW_ACCELERATION:Float = 0.1;

    public static var GLOW_LIGHT_MIN_RADIUS:Float = 20;
    public static var GLOW_LIGHT_MAX_RADIUS:Float = 220;
    public static var GLOW_LIGHT_MIN_SPEED:Float = 1;
    public static var GLOW_LIGHT_MAX_SPEED:Float = 4;
    public static var GLOW_LIGHT_ACCELERATION:Float = 2;
    
    public static var EXIT_COLOR:Color = Color.YELLOW;
    public static var WALL_COLOR:Color = Color.RED;

    public static var GLOW_FALL_ACCELERATION:Float = 0.2;
    public static var GLOW_JUMP_ACCELERATION:Float = -5;
}
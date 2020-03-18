package engine;

class Color {
  public var r:Float;
  public var g:Float;
  public var b:Float;

  public static var RED(get, never):Color;
  static function get_RED():Color return new Color(1, 0, 0);

  public static var GREEN(get, never):Color;
  static function get_GREEN():Color return new Color(0, 1, 0);

  public static var BLUE(get, never):Color;
  static function get_BLUE():Color return new Color(0, 0, 1);

  public static var YELLOW(get, never):Color;
  static function get_YELLOW():Color return new Color(1, 1, 0);

  public static var WHITE(get, never):Color;
  static function get_WHITE():Color return new Color(1, 1, 1);

  public static var BLACK(get, never):Color;
  static function get_BLACK():Color return new Color(0, 0, 0);

  private function new(r:Float, g:Float, b:Float) {
      this.r = correctColor(r);
      this.g = correctColor(g);
      this.b = correctColor(b);
  }

  public static function correctColor(value:Float):Float {
      if(value < 0)
          return 0;
      
      if(value > 1)
          return 1;

      return value;
  }
}
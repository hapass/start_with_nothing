package game;

import engine.Debug;
import haxe.ds.Map;
import haxe.macro.Expr;
import haxe.macro.Context;

using engine.FloatExtensions;
using Lambda;

class Bezier {
    public var bezier:Array<Float>;

    public function new() {
        this.bezier = create();
    }

    public static macro function create():Expr {
        var bezierFunctionX = (t:Float)->{
            var t1 = 1 - t;
            return 3*t1*t1*t*Config.GLOW_LIGHT_P0 + 3*t1*t*t*Config.GLOW_LIGHT_P2 + t*t*t;
        };
        var bezierFunctionY = (t:Float)->{
            var t1 = 1 - t;
            return 3*t1*t1*t*Config.GLOW_LIGHT_P1 + 3*t1*t*t*Config.GLOW_LIGHT_P3 + t*t*t;
        };

        var bezierX:Array<Float> = new Array<Float>();
        var bezierY:Array<Float> = new Array<Float>();
        var t = 0.0;
        while (t < 1.0) {
            bezierX.push(bezierFunctionX(t));
            bezierY.push(bezierFunctionY(t));
            t += 0.05;
        }

        bezierX.push(bezierFunctionX(1.0));
        bezierY.push(bezierFunctionY(1.0));

        // var doublePrecision = function(f:Float):String {
        //     var xStr = Std.string(f);
        //     var xStrParts = xStr.split(".");
        //     if (xStrParts.length == 1) {
        //         return xStrParts[0];
        //     }

        //     if (xStrParts[1].length == 1) {
        //         return xStrParts[0] + "." + xStrParts[1].charAt(0) + "0";
        //     }

        //     return xStrParts[0] + "." + xStrParts[1].charAt(0) + xStrParts[1].charAt(1);
        // };

        // var totalPlot:String = "";
        // for (index in 0...bezierX.length) {
        //     totalPlot += '{${doublePrecision(bezierX[index])},${doublePrecision(bezierY[index])}}';
        // }
        // trace(totalPlot);

        var expressions:Array<Expr> = new Array<Expr>();

        var time = 0.0;
        var totalTime = Config.GLOW_LIGHT_TIME * 1000;
        while (time < totalTime) {
            var normalizedTime = time / totalTime;

            for (index in 1...bezierX.length) {
                if (normalizedTime <= bezierX[index]) {
                    var result = bezierY[index - 1] + (bezierY[index] - bezierY[index - 1]) * (normalizedTime - bezierX[index - 1]) / (bezierX[index] - bezierX[index - 1]);
                    //trace('${time} - ${result}');
                    expressions.push(macro $v{result});
                    break;
                }
            }

            time += 16.0;
        }

        return macro $a{expressions};
    }
}
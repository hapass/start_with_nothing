package lang;

import haxe.macro.Expr;
import haxe.macro.Context;

class Debug {
    public static macro function assert(condition:Expr, message:Expr) {
        var isDebug = Context.getDefines().get("debug") == "1";
        return macro {
            if ($v{isDebug} && !($condition)) {
                throw ("Assertion failed with message: " + $message);
            }
        };
    }
}
package lang;

import haxe.macro.Expr;
import haxe.macro.Compiler;

class Debug {
    public static macro function assert(condition: Expr, message: Expr) {
        var isDebug = Compiler.getDefine("debug") == "1";
        return macro {
            if ($v{isDebug} && !($condition)) {
                throw ("Assertion failed with message: " + $message);
            }
        };
    }
}
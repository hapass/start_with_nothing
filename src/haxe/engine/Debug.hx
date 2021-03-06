package engine;

class Debug {
    public static inline function assert(condition:Bool, message:String) {
        #if debug
        if (!condition) {
            throw ("Assertion failed with message: " + message);
        }
        #end
    }

    public static inline function log(message:String) {
        #if debug
            trace(message);
        #end
    }
}
package game;

#if macro
import haxe.macro.Expr;
#end

class LightAnimation {
    public var isPlaying:Bool = false;
    public var currentFrame:Int = 0;
    public var frames:Array<Float>;
    #if !macro
    public var audio:Audio;
    #end

    public function new(#if !macro audio:Audio #end) {
        this.frames = getFrames();
        #if !macro
        this.audio = audio;
        #end
    }

    public function play() {
        this.currentFrame = 0;
        this.isPlaying = true;
        #if !macro
        this.audio.play();
        #end
    }

    public function updateRadius():Float {
        if (this.currentFrame == this.frames.length) {
            this.currentFrame = 0;
            this.isPlaying = false;
            #if !macro
            this.audio.stop();
            #end
        } 

        if (this.isPlaying) {
            var minRadius = Config.GLOW_LIGHT_MIN_RADIUS;
            var radiusDistance = Config.GLOW_LIGHT_MAX_RADIUS - Config.GLOW_LIGHT_MIN_RADIUS;
            var currentRadius = minRadius + radiusDistance * this.frames[this.currentFrame];
            #if !macro
            this.audio.setValue(Config.GLOW_LIGHT_MIN_FREQUENCY + (Config.GLOW_LIGHT_MAX_FREQUENCY - Config.GLOW_LIGHT_MIN_FREQUENCY) * this.frames[this.currentFrame]);
            #end
            this.currentFrame++;
            return currentRadius;
        }
        
        return 0.0;
    }

    private static macro function getFrames():Expr {
        var bezierFunctionX = (t:Float)->{
            var b = 1 - t;
            return 3*b*b*t*Config.GLOW_LIGHT_P0 + 3*b*t*t*Config.GLOW_LIGHT_P2 + t*t*t;
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

        var expressions:Array<Expr> = new Array<Expr>();

        var time = 0.0;
        var totalTime = Config.GLOW_LIGHT_TIME * 1000;
        while (time < totalTime) {
            var normalizedTime = time / totalTime;

            for (index in 1...bezierX.length) {
                var segmentBeginY = bezierY[index - 1];
                var segmentLengthY = bezierY[index] - bezierY[index - 1];
                var segmentLengthX = bezierX[index] - bezierX[index - 1];
                var segmentOffsetX = normalizedTime - bezierX[index - 1];

                if (normalizedTime <= bezierX[index]) {
                    var interpolatedY = segmentBeginY + segmentLengthY * segmentOffsetX / segmentLengthX;
                    expressions.push(macro $v{interpolatedY});
                    break;
                }
            }

            time += 16.0;
        }

        return macro $a{expressions};
    }
}
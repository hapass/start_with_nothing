package engine.graphics;

import engine.input.Key;
import lang.Debug;
import engine.math.Vec2;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.html.webgl.Buffer;
import js.html.webgl.UniformLocation;
import js.html.CanvasElement;
import js.lib.Float32Array;
import js.Browser;

class Color {
    public var r(default, null):Float;
    public var g(default, null):Float;
    public var b(default, null):Float;

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

    private function correctColor(value:Float):Float {
        Debug.assert(value >= 0 && value <= 1, "Each color value should be between 0 and 1.");

        if(value < 0)
            return 0;
        
        if(value > 1)
            return 1;

        return value;
    }
}

class Quad {
    public var color:Color = Color.WHITE;
    public var height:Float = 0;
    public var width:Float = 0;
    public var position:Vec2<Float> = new Vec2Float();

    public function new() {}
}

class Renderer {
    private var context:RenderingContext;
    private var canvas:CanvasElement;
    private var quads:Array<Quad>;
    private var glowIndex:Int;

    private static inline var CANVAS_WIDTH_PROPERTY = "width";
    private static inline var CANVAS_HEIGHT_PROPERTY = "height";

    private var quadDrawingProgram:QuadDrawingProgram;

    public function new(gameWidth:Int, gameHeight:Int) {
        this.quads = new Array<Quad>();
        this.glowIndex = 0;
        this.canvas = createCanvas(gameWidth, gameHeight);
        this.context = canvas.getContextWebGL();
        this.context.viewport(0, 0, context.canvas.width, context.canvas.height);

        if(context == null)
            throw "Your browser doesn't support webgl. Please update your browser.";

        var compiler = new ProgramCompiler(context);
        this.quadDrawingProgram = new QuadDrawingProgram(context, compiler, gameWidth, gameHeight);
    }

    private function createCanvas(gameWidth:Int, gameHeight:Int) { 
        var canvas = Browser.document.createCanvasElement();
        var canvasHeight = Browser.document.body.clientHeight;
        var canvasWidth = Browser.document.body.clientHeight * (gameWidth / gameHeight);
        canvas.setAttribute(CANVAS_WIDTH_PROPERTY, Std.string(canvasWidth));
        canvas.setAttribute(CANVAS_HEIGHT_PROPERTY, Std.string(canvasHeight));
        canvas.style.marginLeft = Std.string((Browser.document.body.clientWidth - canvasWidth) / 2) + "px";
        Browser.document.body.appendChild(canvas);
        return canvas;
    }

    public function add(quadArray:Array<Quad>) {
        for (quad in quadArray) {
            this.quads.push(quad);
            if (quad.color == Color.WHITE) {
                this.glowIndex = this.quads.length - 1;
            }
        }
    }

    public function draw() {
        clear();
        this.quadDrawingProgram.drawQuads(this.quads, this.glowIndex);
    }

    private function clear() {
        context.clearColor(0, 0, 0, 1);
        context.clear(RenderingContext.COLOR_BUFFER_BIT);
    }

    public function dispose() {
        this.quadDrawingProgram.dispose();
        this.context.finish();
        Browser.document.body.removeChild(this.canvas);
    }
}

private class QuadDrawingProgram {
    private static inline var PROJECTION_UNIFORM_NAME:String = "projection";
    private static inline var GLOW_POSITION_UNIFORM_NAME:String = "glow_position";
    private static inline var TIME_UNIFORM_NAME:String = "rand";
    private static inline var QUAD_POSITION_ATTRIBUTE_NAME:String = "quad_position";
    private static inline var QUAD_COLOR_ATTRIBUTE_NAME:String = "quad_color";
    private static inline var PROGRAM_ID:String = "quad_drawing_program";
    private static inline var VERTEX_SHADER_NAME:String = "VertexShader.glsl";
    private static inline var FRAGMENT_SHADER_NAME:String = "FragmentShader.glsl";
    private static inline var VEC2_DIMENSIONS_NUMBER = 2;
    private static inline var VEC3_DIMENSIONS_NUMBER = 3;

    private var program:Program;
    private var context:RenderingContext;
    private var quadVertexBuffer:Buffer;
    private var vertexArray:Float32Array;
    private var gameWidth:Int;
    private var gameHeight:Int;

    private var animatingGlow:Bool = false;
    private var glowRadius:Float = 0;
    private var glowRadiusSpeed:Float = 0.001;

    private var projection:UniformLocation;
    private var glowPosition:UniformLocation;
    private var rand:UniformLocation;

    public function new(context:RenderingContext, compiler:ProgramCompiler, gameWidth:Int, gameHeight:Int) {
        this.gameWidth = gameWidth;
        this.gameHeight = gameHeight;
        this.vertexArray = new Float32Array(0);
        compiler.compileProgram(PROGRAM_ID, VERTEX_SHADER_NAME, FRAGMENT_SHADER_NAME);
        this.program = compiler.getProgram(PROGRAM_ID);

        this.context = context;
        this.quadVertexBuffer = this.context.createBuffer();
        this.context.bindBuffer(RenderingContext.ARRAY_BUFFER, this.quadVertexBuffer);

        setupQuadPositionAttribute();
        setupQuadColorAttribute();

        this.projection = this.context.getUniformLocation(program, PROJECTION_UNIFORM_NAME);
        this.glowPosition = this.context.getUniformLocation(program, GLOW_POSITION_UNIFORM_NAME);
        this.rand = this.context.getUniformLocation(program, TIME_UNIFORM_NAME);
        this.context.useProgram(program);
        setProjection();
    }

    private function setupQuadPositionAttribute() {
        var positionAttributeLocation = context.getAttribLocation(program, QUAD_POSITION_ATTRIBUTE_NAME);
        this.context.enableVertexAttribArray(positionAttributeLocation);
        this.context.vertexAttribPointer(positionAttributeLocation, VEC2_DIMENSIONS_NUMBER, RenderingContext.FLOAT, false, VEC2_DIMENSIONS_NUMBER * 4 + VEC3_DIMENSIONS_NUMBER * 4, 0);
    }

    private function setupQuadColorAttribute() {
        var colorAttributeLocation = context.getAttribLocation(program, QUAD_COLOR_ATTRIBUTE_NAME);
        this.context.enableVertexAttribArray(colorAttributeLocation);
        this.context.vertexAttribPointer(colorAttributeLocation, VEC3_DIMENSIONS_NUMBER, RenderingContext.FLOAT, false, VEC2_DIMENSIONS_NUMBER * 4 + VEC3_DIMENSIONS_NUMBER * 4, VEC2_DIMENSIONS_NUMBER * 4);
    }

    private var randFloat1:Float = 0;
    private var randFloat2:Float = 0;
    private var randFloat3:Float = 0;

    public function drawQuads(quadArray:Array<Quad>, glowIndex:Int) {
        if (Key.SHIFT.currentState == Key.KEY_DOWN && 
            Key.SHIFT.previousState == Key.KEY_UP) {
            this.glowRadius = 0;
            this.glowRadiusSpeed = 0.001;
            this.animatingGlow = true;
            randFloat1 = Math.random();
            randFloat2 = Math.random();
            randFloat3 = Math.random();
        }

        if (this.animatingGlow) {
            this.glowRadiusSpeed += 0.0003;
            this.glowRadius += glowRadiusSpeed;
            if (this.glowRadius > 1) {
                this.glowRadius = 0;
                this.animatingGlow = false;
            }
        }

        this.context.uniform3f(this.rand, randFloat1, randFloat2, randFloat3);
        this.context.uniform3f(this.glowPosition, quadArray[glowIndex].position.x + (quadArray[glowIndex].width / 2), quadArray[glowIndex].position.y + (quadArray[glowIndex].height / 2), this.glowRadius);

        var vertexCount = 6 * quadArray.length;
        var attributeCount = 5 * vertexCount;

        if (this.vertexArray.length != attributeCount) {
            this.vertexArray = new Float32Array(attributeCount);
        }

        for (i in 0...quadArray.length) {
            var index = i * 30;
            this.vertexArray[index] = quadArray[i].position.x;
            this.vertexArray[index+1] = quadArray[i].position.y;
            this.vertexArray[index+2] = quadArray[i].color.r;
            this.vertexArray[index+3] = quadArray[i].color.g;
            this.vertexArray[index+4] = quadArray[i].color.b;

            this.vertexArray[index+5] = quadArray[i].width + quadArray[i].position.x;
            this.vertexArray[index+6] = quadArray[i].position.y;
            this.vertexArray[index+7] = quadArray[i].color.r;
            this.vertexArray[index+8] = quadArray[i].color.g;
            this.vertexArray[index+9] = quadArray[i].color.b;

            this.vertexArray[index+10] = quadArray[i].position.x;
            this.vertexArray[index+11] = quadArray[i].height + quadArray[i].position.y;
            this.vertexArray[index+12] = quadArray[i].color.r;
            this.vertexArray[index+13] = quadArray[i].color.g;
            this.vertexArray[index+14] = quadArray[i].color.b;

            this.vertexArray[index+15] = quadArray[i].position.x;
            this.vertexArray[index+16] = quadArray[i].height + quadArray[i].position.y;
            this.vertexArray[index+17] = quadArray[i].color.r;
            this.vertexArray[index+18] = quadArray[i].color.g;
            this.vertexArray[index+19] = quadArray[i].color.b;

            this.vertexArray[index+20] = quadArray[i].width + quadArray[i].position.x;
            this.vertexArray[index+21] = quadArray[i].position.y;
            this.vertexArray[index+22] = quadArray[i].color.r;
            this.vertexArray[index+23] = quadArray[i].color.g;
            this.vertexArray[index+24] = quadArray[i].color.b;

            this.vertexArray[index+25] = quadArray[i].width + quadArray[i].position.x;
            this.vertexArray[index+26] = quadArray[i].height + quadArray[i].position.y;
            this.vertexArray[index+27] = quadArray[i].color.r;
            this.vertexArray[index+28] = quadArray[i].color.g;
            this.vertexArray[index+29] = quadArray[i].color.b;
        }
        this.context.bufferData(RenderingContext.ARRAY_BUFFER, this.vertexArray, RenderingContext.DYNAMIC_DRAW);
        this.context.drawArrays(RenderingContext.TRIANGLES, 0, vertexCount);
    }

    private function setProjection() {
        var w = this.gameWidth;
        var h = this.gameHeight;

        this.context.uniformMatrix4fv(this.projection, false, [
            2/w,    0, 0, 0,
              0, -2/h, 0, 0,
              0,    0, 1, 0,
             -1,    1, 0, 1
        ]);
    }

    public function dispose() {
        this.context.deleteProgram(this.program);
        this.context.deleteBuffer(this.quadVertexBuffer);
    }
}

private class ProgramCompiler {

    private var programs:Map<String, Program> = new Map<String, Program>();
    private var context:RenderingContext = null;

    public function new(context:RenderingContext) {
        this.context = context;
    }

    public function compileProgram(name:String, vertexShaderName:String, fragmentShaderName:String):Void {
        var program = context.createProgram();

        context.attachShader(program, compileShader(vertexShaderName, RenderingContext.VERTEX_SHADER));
        context.attachShader(program, compileShader(fragmentShaderName, RenderingContext.FRAGMENT_SHADER));
        context.linkProgram(program);

        if(!context.getProgramParameter(program, RenderingContext.LINK_STATUS)) {
            Debug.log(context.getProgramInfoLog(program));
            context.deleteProgram(program);
            throw "Program linking error. " + "Program name: " + name;
        }

        programs.set(name, program);
    }

    private function compileShader(name:String, type:Int) {
        Debug.assert(Browser.document.getElementById(name) != null, "Shaders should be present in the html page.");

        var shaderSource = Browser.document.getElementById(name).innerText;
        var shader = context.createShader(type);

        context.shaderSource(shader, shaderSource);
        context.compileShader(shader);

        if(!context.getShaderParameter(shader, RenderingContext.COMPILE_STATUS)) {
            Debug.log(context.getShaderInfoLog(shader));
            context.deleteShader(shader);
            throw "Shader compilation error. " + "Shader file name: " + name;
        }

        return shader;
    }

    public function getProgram(name:String):Program {
        if(!programs.exists(name))
            throw "The program hasn't been compiled yet. " + "Program name: " + name;

        return programs.get(name);
    }
}
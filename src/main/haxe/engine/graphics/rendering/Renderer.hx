package engine.graphics.rendering;

import lang.Debug;
import engine.math.Vec2;
import engine.math.Vec3;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.html.webgl.Buffer;
import js.html.webgl.UniformLocation;
import js.html.CanvasElement;
import js.lib.Float32Array;
import js.Browser;

using Lambda;

class Renderer {
    private var context:RenderingContext;
    private var canvas:CanvasElement;

    private static inline var CANVAS_WIDTH_PROPERTY = "width";
    private static inline var CANVAS_HEIGHT_PROPERTY = "height";

    private var quadDrawingProgram:QuadDrawingProgram;

    public function new(canvasWidth:Int, canvasHeight:Int) {
        this.canvas = createCanvas(canvasWidth, canvasHeight);
        this.context = canvas.getContextWebGL();
        this.context.viewport(0, 0, context.canvas.width, context.canvas.height);

        if(context == null)
            throw "Your browser doesn't support webgl. Please update your browser.";

        var compiler = new ProgramCompiler(context);
        this.quadDrawingProgram = new QuadDrawingProgram(context, compiler);
    }

    private function createCanvas(width:Int, height:Int) { 
        var canvas = Browser.document.createCanvasElement();
        canvas.setAttribute(CANVAS_WIDTH_PROPERTY, Std.string(width));
        canvas.setAttribute(CANVAS_HEIGHT_PROPERTY, Std.string(height));
        Browser.document.body.appendChild(canvas);
        return canvas;
    }

    public function drawQuad(translation:Vec2, width:Int, height:Int, color:Vec3) {
        this.quadDrawingProgram.drawQuad(translation, width, height, color);
    }

    public function clear() {
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
    private static inline var SCREEN_SIZE_UNIFORM_NAME: String = "projection";
    private static inline var TRANSLATION_UNIFORM_NAME: String = "translation";
    private static inline var SCALE_UNIFORM_NAME: String = "scale";
    private static inline var COLOR_UNIFORM_NAME: String = "color";
    private static inline var QUAD_POSITION_ATTRIBUTE_NAME: String = "quad_position";
    private static inline var PROGRAM_ID: String = "quad_drawing_program";
    private static inline var VERTEX_SHADER_NAME: String = "VertexShader";
    private static inline var FRAGMENT_SHADER_NAME: String = "FragmentShader";
    private static inline var VEC2_DIMENSIONS_NUMBER = 2;

    private var program:Program;
    private var context:RenderingContext;
    private var quadVertexBuffer:Buffer;

    private var projection:UniformLocation;
    private var translation:UniformLocation;
    private var scale:UniformLocation;
    private var color:UniformLocation;

    public function new(context:RenderingContext, compiler:ProgramCompiler) {
        
        compiler.compileProgram(PROGRAM_ID, VERTEX_SHADER_NAME, FRAGMENT_SHADER_NAME);
        this.program = compiler.getProgram(PROGRAM_ID);

        this.context = context;
        this.quadVertexBuffer = this.context.createBuffer();
        this.context.bindBuffer(RenderingContext.ARRAY_BUFFER, this.quadVertexBuffer);
        this.context.bufferData(RenderingContext.ARRAY_BUFFER, new Float32Array(getQuadVertices().flatten().array()), RenderingContext.STATIC_DRAW);

        setupQuadPositionAttribute();

        this.projection = this.context.getUniformLocation(program, SCREEN_SIZE_UNIFORM_NAME);
        this.translation = this.context.getUniformLocation(program, TRANSLATION_UNIFORM_NAME);
        this.scale = this.context.getUniformLocation(program, SCALE_UNIFORM_NAME);
        this.color = this.context.getUniformLocation(program, COLOR_UNIFORM_NAME);

        this.context.useProgram(program);
    }

    private function setupQuadPositionAttribute() {
        var positionAttributeLocation = context.getAttribLocation(program, QUAD_POSITION_ATTRIBUTE_NAME);
        this.context.enableVertexAttribArray(positionAttributeLocation);
        this.context.vertexAttribPointer(positionAttributeLocation, VEC2_DIMENSIONS_NUMBER, RenderingContext.FLOAT, false, 0, 0);
    }

    public function drawQuad(position:Vec2, width:Int, height:Int, color:Vec3) {
        setProjection();
        setColor(color);
        setTranslation(position);
        setScale(width, height);

        this.context.drawArrays(RenderingContext.TRIANGLE_STRIP, 0, 4);
    }

    private function setTranslation(position:Vec2) {
        var x = position.x;
        var y = position.y;

        this.context.uniformMatrix4fv(this.translation, false, [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            x, y, 0, 1,
        ]);
    }

    private function setScale(width:Int, height:Int) {
        var w = width;
        var h = height;

        this.context.uniformMatrix4fv(this.scale, false, [
            w, 0, 0, 0,
            0, h, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        ]);
    }

    private function setProjection() {
        var w = this.context.canvas.width;
        var h = this.context.canvas.height;

        this.context.uniformMatrix4fv(this.projection, false, [
            2/w,    0, 0, 0,
              0, -2/h, 0, 0,
              0,    0, 1, 0,
             -1,    1, 0, 1
        ]);
    }

    private function setColor(color:Vec3) {
        this.context.uniform4fv(this.color, [color.x, color.y, color.z, 1]);
    }

    private function getQuadVertices() {
        return [
            new Vec2(0, 1),
            new Vec2(0, 0),
            new Vec2(1, 1),
            new Vec2(1, 0),
        ];
    }

    public function dispose() {
        this.context.deleteProgram(this.program);
        this.context.deleteBuffer(this.quadVertexBuffer);
    }
}

private class ProgramCompiler {

    private var programs:Map<String, Program>;
    private var context:RenderingContext;

    public function new(context:RenderingContext) {
        this.context = context;
        this.programs = new Map<String, Program>();
    }

    public function compileProgram(name:String, vertexShaderName:String, fragmentShaderName:String):Void {
        var program = context.createProgram();

        context.attachShader(program, compileShader(vertexShaderName, RenderingContext.VERTEX_SHADER));
        context.attachShader(program, compileShader(fragmentShaderName, RenderingContext.FRAGMENT_SHADER));
        context.linkProgram(program);

        if(!context.getProgramParameter(program, RenderingContext.LINK_STATUS)) {
            trace(context.getProgramInfoLog(program));
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
            trace(context.getShaderInfoLog(shader));
            context.deleteShader(shader);
            throw "Shader compilation error. " + "Shader file name: " + name;
        }

        return shader;
    }

    public function getProgram(name: String): Program {
        if(!programs.exists(name))
            throw "The program hasn't been compiled yet. " + "Program name: " + name;

        return programs.get(name);
    }
}
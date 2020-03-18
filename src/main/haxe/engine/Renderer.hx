package engine;

import haxe.Resource;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.html.webgl.Buffer;
import js.html.webgl.UniformLocation;
import js.html.CanvasElement;
import js.lib.Float32Array;
import js.Browser;

class Renderer {
    private var context:RenderingContext;
    private var canvas:CanvasElement;
    private var quads:Array<Quad>;
    private var light:Light;

    private static inline var CANVAS_WIDTH_PROPERTY = "width";
    private static inline var CANVAS_HEIGHT_PROPERTY = "height";

    private var quadDrawingProgram:QuadDrawingProgram;

    public function new(gameWidth:Int, gameHeight:Int) {
        this.quads = new Array<Quad>();
        this.light = new Light();
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

    public function setLight(light:Light) {
        this.light = light;
    }

    public function add(quadArray:Array<Quad>) {
        for (quad in quadArray) {
            this.quads.push(quad);
        }
    }

    public function draw() {
        clear();
        this.quadDrawingProgram.drawQuads(this.quads, this.light);
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
    private static inline var CLIP_SPACE_PROJECTION_UNIFORM_NAME:String = "clip_space_projection";
    private static inline var SCREEN_SPACE_PROJECTION_UNIFORM_NAME:String = "screen_space_projection";
    private static inline var LIGHT_CONFIGURATION_UNIFORM_NAME:String = "light_configuration";
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

    private var clipSpaceProjection:UniformLocation;
    private var screenSpaceProjection:UniformLocation;
    private var lightConfiguration:UniformLocation;

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

        this.clipSpaceProjection = this.context.getUniformLocation(program, CLIP_SPACE_PROJECTION_UNIFORM_NAME);
        this.screenSpaceProjection = this.context.getUniformLocation(program, SCREEN_SPACE_PROJECTION_UNIFORM_NAME);
        this.lightConfiguration = this.context.getUniformLocation(program, LIGHT_CONFIGURATION_UNIFORM_NAME);

        this.context.useProgram(program);
        setClipSpaceProjection();
        setScreenSpaceProjection();
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

    public function drawQuads(quadArray:Array<Quad>, light:Light) {
        this.context.uniform3f(this.lightConfiguration, light.position.x, light.position.y, light.radius);

        var vertexCount = 6 * quadArray.length;
        var attributeCount = 5 * vertexCount;

        if (this.vertexArray.length != attributeCount) {
            this.vertexArray = new Float32Array(attributeCount);
        }

        for (i in 0...quadArray.length) {
            var index = i * 30;
            this.vertexArray[index] = quadArray[i].position.x;
            this.vertexArray[index+1] = quadArray[i].position.y;
            this.vertexArray[index+2] = Color.correctColor(quadArray[i].color.r + light.color.r);
            this.vertexArray[index+3] = Color.correctColor(quadArray[i].color.g + light.color.g);
            this.vertexArray[index+4] = Color.correctColor(quadArray[i].color.b + light.color.b);

            this.vertexArray[index+5] = quadArray[i].size + quadArray[i].position.x;
            this.vertexArray[index+6] = quadArray[i].position.y;
            this.vertexArray[index+7] = Color.correctColor(quadArray[i].color.r + light.color.r);
            this.vertexArray[index+8] = Color.correctColor(quadArray[i].color.g + light.color.g);
            this.vertexArray[index+9] = Color.correctColor(quadArray[i].color.b + light.color.b);

            this.vertexArray[index+10] = quadArray[i].position.x;
            this.vertexArray[index+11] = quadArray[i].size + quadArray[i].position.y;
            this.vertexArray[index+12] = Color.correctColor(quadArray[i].color.r + light.color.r);
            this.vertexArray[index+13] = Color.correctColor(quadArray[i].color.g + light.color.g);
            this.vertexArray[index+14] = Color.correctColor(quadArray[i].color.b + light.color.b);

            this.vertexArray[index+15] = quadArray[i].position.x;
            this.vertexArray[index+16] = quadArray[i].size + quadArray[i].position.y;
            this.vertexArray[index+17] = Color.correctColor(quadArray[i].color.r + light.color.r);
            this.vertexArray[index+18] = Color.correctColor(quadArray[i].color.g + light.color.g);
            this.vertexArray[index+19] = Color.correctColor(quadArray[i].color.b + light.color.b);

            this.vertexArray[index+20] = quadArray[i].size + quadArray[i].position.x;
            this.vertexArray[index+21] = quadArray[i].position.y;
            this.vertexArray[index+22] = Color.correctColor(quadArray[i].color.r + light.color.r);
            this.vertexArray[index+23] = Color.correctColor(quadArray[i].color.g + light.color.g);
            this.vertexArray[index+24] = Color.correctColor(quadArray[i].color.b + light.color.b);

            this.vertexArray[index+25] = quadArray[i].size + quadArray[i].position.x;
            this.vertexArray[index+26] = quadArray[i].size + quadArray[i].position.y;
            this.vertexArray[index+27] = Color.correctColor(quadArray[i].color.r + light.color.r);
            this.vertexArray[index+28] = Color.correctColor(quadArray[i].color.g + light.color.g);
            this.vertexArray[index+29] = Color.correctColor(quadArray[i].color.b + light.color.b);
        }

        this.context.bufferData(RenderingContext.ARRAY_BUFFER, this.vertexArray, RenderingContext.DYNAMIC_DRAW);
        this.context.drawArrays(RenderingContext.TRIANGLES, 0, vertexCount);
    }

    private function setClipSpaceProjection() {
        var w = this.gameWidth;
        var h = this.gameHeight;
        var tw = 2;
        var th = 2;

        this.context.uniformMatrix4fv(this.clipSpaceProjection, false, [
            tw/w,     0, 0, 0,
               0, -th/h, 0, 0,
               0,     0, 1, 0,
              -1,     1, 0, 1
        ]);
    }

    private function setScreenSpaceProjection() {
        var w = this.gameWidth;
        var h = this.gameHeight;
        var tw = this.context.canvas.width;
        var th = this.context.canvas.height;

        var r = Math.sqrt(w * w + h * h);
        var tr = Math.sqrt(tw * tw + th * th);

        this.context.uniformMatrix4fv(this.screenSpaceProjection, false, [
            tw/w,     0,    0, 0,
               0, -th/h,    0, 0,
               0,     0, tr/r, 0,
               0,    th,    0, 1
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
        var shader = context.createShader(type);

        context.shaderSource(shader, Resource.getString(name));
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
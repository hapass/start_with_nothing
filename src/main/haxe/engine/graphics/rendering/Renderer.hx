package engine.graphics.rendering;

import lang.Debug;

import engine.math.Vec3;
import engine.math.Vec2;

import js.html.webgl.RenderingContext;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;

import js.html.Image;

import js.html.Float32Array;

import js.Browser;

class Renderer {
    private var context: RenderingContext;

    private static inline var CANVAS_WIDTH_PROPERTY = "width";
    private static inline var CANVAS_HEIGHT_PROPERTY = "height";

    private var primitiveDrawingProgram: PrimitiveDrawingProgram;
    private var textureDrawingProgram: TextureDrawingProgram;

    public function new(canvasWidth: Int, canvasHeight: Int) {
        var canvas = createCanvas(canvasWidth, canvasHeight);
        this.context = canvas.getContextWebGL();

        if(context == null)
            throw "Your browser doesn't support webgl. Please update your browser.";

        var compiler = new ProgramCompiler(context);
        this.primitiveDrawingProgram = new PrimitiveDrawingProgram(context, compiler);
        this.textureDrawingProgram = new TextureDrawingProgram(context, compiler);
    }

    private function createCanvas(canvasWidth: Int, canvasHeight: Int){ 
        var canvas = Browser.document.createCanvasElement();
        canvas.setAttribute(CANVAS_WIDTH_PROPERTY, Std.string(canvasWidth));
        canvas.setAttribute(CANVAS_HEIGHT_PROPERTY, Std.string(canvasHeight));
        Browser.document.body.appendChild(canvas);
        return canvas;
    }

    public function drawTriangleStrip(vertices: Array<Vec2>, color: Vec3) {
        Debug.assert(isColorValid(color), "Color components should each have the value between 0 and 256.");  
        primitiveDrawingProgram.draw(vertices, color);
    }

    public function drawTriangleStripTexture(vertices: Array<Vec2>, texture: Image) {
        textureDrawingProgram.draw(vertices, texture);
    }

    public function clear() {
        context.viewport(0, 0, context.canvas.width, context.canvas.height);                
        context.clearColor(0, 0, 0, 1);
        context.clear(RenderingContext.COLOR_BUFFER_BIT);
    }

    private function isColorValid(color: Vec3) {
        return color.x >= 0 && color.x <= 256 && 
               color.y >= 0 && color.y <= 256 && 
               color.z >= 0 && color.z <= 256;
    }
}

private class PrimitiveDrawingProgram {
    private static inline var COLOR_UNIFORM_NAME: String = "color";
    private static inline var SCREEN_SIZE_UNIFORM_NAME: String = "screen_size";
    private static inline var VERTEX_ATTRIBUTE_NAME: String = "vertex_position";
    private static inline var PROGRAM_ID: String = "simple_drawing_program";
    private static inline var VERTEX_SHADER_NAME: String = "PrimitiveVertexShader";
    private static inline var FRAGMENT_SHADER_NAME: String = "PrimitiveFragmentShader";
    private static inline var VEC2_DIMENSIONS_NUMBER = 2;

    private var program: Program;
    private var context: RenderingContext;

    public function new(context: RenderingContext, compiler: ProgramCompiler) {
        compiler.compileProgram(PROGRAM_ID, VERTEX_SHADER_NAME, FRAGMENT_SHADER_NAME);
        this.program = compiler.getProgram(PROGRAM_ID);
        this.context = context;
    }

    public function draw(vertices: Array<Vec2>, color: Vec3, mode: Int = RenderingContext.TRIANGLE_STRIP) {
        context.useProgram(program);
        setVertices(vertices);
        setScreenSize();
        setColor(color);
        context.drawArrays(mode, 0, vertices.length);
    }

    private function setVertices(vertices: Array<Vec2>) {
        var positionAttributeLocation = context.getAttribLocation(program, VERTEX_ATTRIBUTE_NAME);        
        context.enableVertexAttribArray(positionAttributeLocation);
        context.bindBuffer(RenderingContext.ARRAY_BUFFER, context.createBuffer());
        context.bufferData(RenderingContext.ARRAY_BUFFER, new Float32Array(flattenVecArray(vertices)), RenderingContext.STATIC_DRAW);
        context.vertexAttribPointer(positionAttributeLocation, VEC2_DIMENSIONS_NUMBER, RenderingContext.FLOAT, false, 0, 0);        
    }

    private function flattenVecArray(vecArray: Array<Vec2>) {
        var flattenedArray: Array<Float> = [];
        for(vec in vecArray) {
            flattenedArray.push(vec.x);
            flattenedArray.push(vec.y);
        }
        return flattenedArray;
    }

    private function setScreenSize() {
        var resolutionUniformLocation = context.getUniformLocation(program, SCREEN_SIZE_UNIFORM_NAME);
        context.uniform2f(resolutionUniformLocation, context.canvas.width, context.canvas.height);
    }

    private function setColor(color: Vec3) {
        var colorUniformLocation = context.getUniformLocation(program, COLOR_UNIFORM_NAME);
        var r = (color.x / 255);
        var g = (color.y / 255);
        var b = (color.z / 255);
        context.uniform3f(colorUniformLocation, r, g, b);
    }
}

private class TextureDrawingProgram {
    private static inline var SCREEN_SIZE_UNIFORM_NAME: String = "screen_size";
    private static inline var TEXTURE_QUAD_POSITION_ATTRIBUTE_NAME: String = "texture_quad_position";
    private static inline var TEXTURE_POSITION_ATTRIBUTE_NAME: String = "texture_position";
    private static inline var PROGRAM_ID: String = "texture_drawing_program";
    private static inline var VERTEX_SHADER_NAME: String = "TextureVertexShader";
    private static inline var FRAGMENT_SHADER_NAME: String = "TextureFragmentShader";
    private static inline var VEC2_DIMENSIONS_NUMBER = 2;

    private var program: Program;
    private var context: RenderingContext;

    public function new(context: RenderingContext, compiler: ProgramCompiler) {
        compiler.compileProgram(PROGRAM_ID, VERTEX_SHADER_NAME, FRAGMENT_SHADER_NAME);
        this.program = compiler.getProgram(PROGRAM_ID);
        this.context = context;
        context.useProgram(program);
    }

    public function draw(vertices: Array<Vec2>, texture: Image, mode: Int = RenderingContext.TRIANGLE_STRIP) {
        context.useProgram(program);        
        setQuadPositionVertices(vertices);
        setTexturePositionVertices();
        setTexture(texture);
        setScreenSize();

        context.drawArrays(mode, 0, vertices.length);
    }

    private function setQuadPositionVertices(vertices: Array<Vec2>) {
        var positionAttributeLocation = context.getAttribLocation(program, TEXTURE_QUAD_POSITION_ATTRIBUTE_NAME);
        context.vertexAttribPointer(positionAttributeLocation, VEC2_DIMENSIONS_NUMBER, RenderingContext.FLOAT, false, 0, 0);
        context.bindBuffer(RenderingContext.ARRAY_BUFFER, context.createBuffer());
        context.bufferData(RenderingContext.ARRAY_BUFFER, new Float32Array(flattenVecArray(vertices)), RenderingContext.STATIC_DRAW);
        context.enableVertexAttribArray(positionAttributeLocation);        
    }

    private function setTexturePositionVertices() {
        var texturePositionAttributeLocation = context.getAttribLocation(program, TEXTURE_POSITION_ATTRIBUTE_NAME);
        context.vertexAttribPointer(texturePositionAttributeLocation, VEC2_DIMENSIONS_NUMBER, RenderingContext.FLOAT, false, 0, 0);
        context.bindBuffer(RenderingContext.ARRAY_BUFFER, context.createBuffer());
        context.bufferData(RenderingContext.ARRAY_BUFFER, new Float32Array(flattenVecArray(getTexturePositionVertices())), RenderingContext.STATIC_DRAW);
        context.enableVertexAttribArray(texturePositionAttributeLocation);        
    }

    private function setTexture(texture: Image) {
        context.activeTexture(RenderingContext.TEXTURE0);
        context.bindTexture(RenderingContext.TEXTURE_2D, context.createTexture());

        context.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_S, RenderingContext.CLAMP_TO_EDGE);
        context.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_T, RenderingContext.CLAMP_TO_EDGE);
        context.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
        context.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);

        context.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, texture);
    }

    private function getTexturePositionVertices() {
        return [
            new Vec2(0.0, 0.0),
            new Vec2(1.0, 0.0),
            new Vec2(0.0, 1.0),
            new Vec2(0.0, 1.0),
            new Vec2(1.0, 0.0),
            new Vec2(1.0, 1.0),
        ];
    }

    private function flattenVecArray(vecArray: Array<Vec2>) {
        var flattenedArray: Array<Float> = [];
        for(vec in vecArray) {
            flattenedArray.push(vec.x);
            flattenedArray.push(vec.y);
        }
        return flattenedArray;
    }

    private function setScreenSize() {
        var resolutionUniformLocation = context.getUniformLocation(program, SCREEN_SIZE_UNIFORM_NAME);
        context.uniform2f(resolutionUniformLocation, context.canvas.width, context.canvas.height);
    }
}

private class ProgramCompiler {

    private var programs: Map<String, Program>;
    private var context: RenderingContext;

    public function new(context: RenderingContext) {
        this.context = context;
        this.programs = new Map<String, Program>();
    }

    public function compileProgram(name: String, vertexShaderName: String, fragmentShaderName: String): Void {
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

    private function compileShader(name: String, type: Int) {
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
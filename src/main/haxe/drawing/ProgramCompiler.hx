package drawing;

import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.Browser;

class ProgramCompiler {

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
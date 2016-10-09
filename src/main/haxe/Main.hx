package;

import js.Browser;
import js.html.webgl.RenderingContext;
import js.html.webgl.Shader;
import js.html.Float32Array;

class Main {
    static function main(){
        var canvas = createCanvas();

        trace("Starting up webgl...");
        var gl: RenderingContext = canvas.getContextWebGL();

        if(gl == null)
            throw "Your browser doesn't support webgl. Please update your browser.";

        var program = getProgram(gl, getVertexShader(gl), getFragmentShader(gl));
        var positionAttributeLocation = gl.getAttribLocation(program, "a_position");
        var positionBuffer = gl.createBuffer();
        gl.bindBuffer(RenderingContext.ARRAY_BUFFER, positionBuffer);
        var positions = [-0.5, -0.5, 0, 0.5, 0.5, -0.5];
        gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32Array(positions), RenderingContext.STATIC_DRAW);
        gl.enableVertexAttribArray(positionAttributeLocation);
        gl.vertexAttribPointer(positionAttributeLocation, 2, RenderingContext.FLOAT, false, 0, 0);
        gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
        gl.clearColor(0, 0, 0, 1);
        gl.clear(RenderingContext.COLOR_BUFFER_BIT);
        gl.useProgram(program);
        gl.drawArrays(RenderingContext.TRIANGLES, 0, 3);
    }

    static function createCanvas(){ 
        var canvas = Browser.document.createCanvasElement();
        canvas.setAttribute("width", "800");
        canvas.setAttribute("height", "600");
        Browser.document.body.appendChild(canvas);
        return canvas;
    }

    static function getVertexShader(gl: RenderingContext){
        var shaderSource = Browser.document.getElementById("VertexShader").innerText;

        var shader = gl.createShader(RenderingContext.VERTEX_SHADER);
        gl.shaderSource(shader, shaderSource);
        gl.compileShader(shader);

        if(!gl.getShaderParameter(shader, RenderingContext.COMPILE_STATUS))
        {
            trace(gl.getShaderInfoLog(shader));
            gl.deleteShader(shader);
            throw "Vertex shader compilation error.";
        }

        return shader;
    }

    static function getFragmentShader(gl: RenderingContext){
        var shaderSource = Browser.document.getElementById("FragmentShader").innerText;

        var shader = gl.createShader(RenderingContext.FRAGMENT_SHADER);
        gl.shaderSource(shader, shaderSource);
        gl.compileShader(shader);

        if(!gl.getShaderParameter(shader, RenderingContext.COMPILE_STATUS)){
            trace(gl.getShaderInfoLog(shader));
            gl.deleteShader(shader);
            throw "Fragment shader compilation error.";
        }

        return shader;
    }

    static function getProgram(gl: RenderingContext, vertexShader: Shader, fragmentShader: Shader){
        var program = gl.createProgram();
        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);
        gl.linkProgram(program);
        if(!gl.getProgramParameter(program, RenderingContext.LINK_STATUS)){
            trace(gl.getProgramInfoLog(program));
            gl.deleteProgram(program);
            throw "Program linking error.";
        }

        return  program;
    }
}
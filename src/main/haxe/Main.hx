package;

import js.Browser;
import js.html.webgl.RenderingContext;
import drawing.Renderer;
import drawing.shapes.Triangle;
import drawing.utils.Vec2;
import drawing.utils.Color;

class Main {
    static function main(){
        var canvas = createCanvas();

        trace("Starting up webgl...");
        var gl: RenderingContext = canvas.getContextWebGL();

        if(gl == null)
            throw "Your browser doesn't support webgl. Please update your browser.";
       
       var renderer = new Renderer(gl);
       renderer.drawTriangle(
           new Triangle(
               new Vec2(0.0, 0.0),
               new Vec2(100.0, 100.0),
               new Vec2(200.0, 200.0),
               new Color(10, 10, 10, 10)));        
    }

    static function createCanvas(){ 
        var canvas = Browser.document.createCanvasElement();
        canvas.setAttribute("width", "800");
        canvas.setAttribute("height", "600");
        Browser.document.body.appendChild(canvas);
        return canvas;
    }
}
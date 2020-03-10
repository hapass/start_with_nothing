// Generated by Haxe 4.0.5
(function ($global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var v = parseInt(x, (x[(i + 1)]=="x" || x[(i + 1)]=="X") ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var engine_data_Data = function() { };
engine_data_Data.__name__ = true;
engine_data_Data.getString = function(id) {
	var element = window.document.getElementById(id);
	return element.getAttribute("data-string");
};
var engine_graphics_Color = function(r,g,b) {
	this.r = this.correctColor(r);
	this.g = this.correctColor(g);
	this.b = this.correctColor(b);
};
engine_graphics_Color.__name__ = true;
engine_graphics_Color.get_RED = function() {
	return new engine_graphics_Color(1,0,0);
};
engine_graphics_Color.get_YELLOW = function() {
	return new engine_graphics_Color(1,1,0);
};
engine_graphics_Color.get_WHITE = function() {
	return new engine_graphics_Color(1,1,1);
};
engine_graphics_Color.prototype = {
	correctColor: function(value) {
		if(value < 0) {
			return 0;
		}
		if(value > 1) {
			return 1;
		}
		return value;
	}
};
var engine_graphics_Quad = function() {
	this.position = new engine_math_Vec2Float();
	this.width = 0;
	this.height = 0;
	this.color = engine_graphics_Color.get_WHITE();
};
engine_graphics_Quad.__name__ = true;
var engine_graphics_Renderer = function(canvasWidth,canvasHeight) {
	this.quads = [];
	this.canvas = this.createCanvas(canvasWidth,canvasHeight);
	this.context = js_html__$CanvasElement_CanvasUtil.getContextWebGL(this.canvas,null);
	this.context.viewport(0,0,this.context.canvas.width,this.context.canvas.height);
	if(this.context == null) {
		throw new js__$Boot_HaxeError("Your browser doesn't support webgl. Please update your browser.");
	}
	var compiler = new engine_graphics__$Renderer_ProgramCompiler(this.context);
	this.quadDrawingProgram = new engine_graphics__$Renderer_QuadDrawingProgram(this.context,compiler);
};
engine_graphics_Renderer.__name__ = true;
engine_graphics_Renderer.prototype = {
	createCanvas: function(width,height) {
		var canvas = window.document.createElement("canvas");
		canvas.setAttribute("width",width == null ? "null" : "" + width);
		canvas.setAttribute("height",height == null ? "null" : "" + height);
		window.document.body.appendChild(canvas);
		return canvas;
	}
	,add: function(quadArray) {
		var _g = 0;
		while(_g < quadArray.length) {
			var quad = quadArray[_g];
			++_g;
			this.quads.push(quad);
		}
	}
	,draw: function() {
		this.clear();
		this.quadDrawingProgram.drawQuads(this.quads);
	}
	,clear: function() {
		this.context.clearColor(0,0,0,1);
		this.context.clear(16384);
	}
	,dispose: function() {
		this.quadDrawingProgram.dispose();
		this.context.finish();
		window.document.body.removeChild(this.canvas);
	}
};
var engine_graphics__$Renderer_QuadDrawingProgram = function(context,compiler) {
	this.vertexArray = new Float32Array(0);
	compiler.compileProgram("quad_drawing_program","VertexShader.glsl","FragmentShader.glsl");
	this.program = compiler.getProgram("quad_drawing_program");
	this.context = context;
	this.quadVertexBuffer = this.context.createBuffer();
	this.context.bindBuffer(34962,this.quadVertexBuffer);
	this.setupQuadPositionAttribute();
	this.setupQuadColorAttribute();
	this.projection = this.context.getUniformLocation(this.program,"projection");
	this.context.useProgram(this.program);
	this.setProjection();
};
engine_graphics__$Renderer_QuadDrawingProgram.__name__ = true;
engine_graphics__$Renderer_QuadDrawingProgram.prototype = {
	setupQuadPositionAttribute: function() {
		var positionAttributeLocation = this.context.getAttribLocation(this.program,"quad_position");
		this.context.enableVertexAttribArray(positionAttributeLocation);
		this.context.vertexAttribPointer(positionAttributeLocation,2,5126,false,20,0);
	}
	,setupQuadColorAttribute: function() {
		var colorAttributeLocation = this.context.getAttribLocation(this.program,"quad_color");
		this.context.enableVertexAttribArray(colorAttributeLocation);
		this.context.vertexAttribPointer(colorAttributeLocation,3,5126,false,20,8);
	}
	,drawQuads: function(quadArray) {
		var vertexCount = 6 * quadArray.length;
		var attributeCount = 5 * vertexCount;
		if(this.vertexArray.length != attributeCount) {
			this.vertexArray = new Float32Array(attributeCount);
		}
		var _g = 0;
		var _g1 = quadArray.length;
		while(_g < _g1) {
			var i = _g++;
			var index = i * 30;
			this.vertexArray[index] = quadArray[i].position.x;
			this.vertexArray[index + 1] = quadArray[i].position.y;
			this.vertexArray[index + 2] = quadArray[i].color.r;
			this.vertexArray[index + 3] = quadArray[i].color.g;
			this.vertexArray[index + 4] = quadArray[i].color.b;
			this.vertexArray[index + 5] = quadArray[i].width + quadArray[i].position.x;
			this.vertexArray[index + 6] = quadArray[i].position.y;
			this.vertexArray[index + 7] = quadArray[i].color.r;
			this.vertexArray[index + 8] = quadArray[i].color.g;
			this.vertexArray[index + 9] = quadArray[i].color.b;
			this.vertexArray[index + 10] = quadArray[i].position.x;
			this.vertexArray[index + 11] = quadArray[i].height + quadArray[i].position.y;
			this.vertexArray[index + 12] = quadArray[i].color.r;
			this.vertexArray[index + 13] = quadArray[i].color.g;
			this.vertexArray[index + 14] = quadArray[i].color.b;
			this.vertexArray[index + 15] = quadArray[i].position.x;
			this.vertexArray[index + 16] = quadArray[i].height + quadArray[i].position.y;
			this.vertexArray[index + 17] = quadArray[i].color.r;
			this.vertexArray[index + 18] = quadArray[i].color.g;
			this.vertexArray[index + 19] = quadArray[i].color.b;
			this.vertexArray[index + 20] = quadArray[i].width + quadArray[i].position.x;
			this.vertexArray[index + 21] = quadArray[i].position.y;
			this.vertexArray[index + 22] = quadArray[i].color.r;
			this.vertexArray[index + 23] = quadArray[i].color.g;
			this.vertexArray[index + 24] = quadArray[i].color.b;
			this.vertexArray[index + 25] = quadArray[i].width + quadArray[i].position.x;
			this.vertexArray[index + 26] = quadArray[i].height + quadArray[i].position.y;
			this.vertexArray[index + 27] = quadArray[i].color.r;
			this.vertexArray[index + 28] = quadArray[i].color.g;
			this.vertexArray[index + 29] = quadArray[i].color.b;
		}
		this.context.bufferData(34962,this.vertexArray,35048);
		this.context.drawArrays(4,0,vertexCount);
	}
	,setProjection: function() {
		var w = this.context.canvas.width;
		var h = this.context.canvas.height;
		this.context.uniformMatrix4fv(this.projection,false,[2 / w,0,0,0,0,-2 / h,0,0,0,0,1,0,-1,1,0,1]);
	}
	,dispose: function() {
		this.context.deleteProgram(this.program);
		this.context.deleteBuffer(this.quadVertexBuffer);
	}
};
var engine_graphics__$Renderer_ProgramCompiler = function(context) {
	this.context = null;
	this.programs = new haxe_ds_StringMap();
	this.context = context;
};
engine_graphics__$Renderer_ProgramCompiler.__name__ = true;
engine_graphics__$Renderer_ProgramCompiler.prototype = {
	compileProgram: function(name,vertexShaderName,fragmentShaderName) {
		var program = this.context.createProgram();
		this.context.attachShader(program,this.compileShader(vertexShaderName,35633));
		this.context.attachShader(program,this.compileShader(fragmentShaderName,35632));
		this.context.linkProgram(program);
		if(!this.context.getProgramParameter(program,35714)) {
			console.log("src/main/haxe/engine/graphics/Renderer.hx:249:",this.context.getProgramInfoLog(program));
			this.context.deleteProgram(program);
			throw new js__$Boot_HaxeError("Program linking error. " + "Program name: " + name);
		}
		var _this = this.programs;
		if(__map_reserved[name] != null) {
			_this.setReserved(name,program);
		} else {
			_this.h[name] = program;
		}
	}
	,compileShader: function(name,type) {
		var shaderSource = window.document.getElementById(name).innerText;
		var shader = this.context.createShader(type);
		this.context.shaderSource(shader,shaderSource);
		this.context.compileShader(shader);
		if(!this.context.getShaderParameter(shader,35713)) {
			console.log("src/main/haxe/engine/graphics/Renderer.hx:267:",this.context.getShaderInfoLog(shader));
			this.context.deleteShader(shader);
			throw new js__$Boot_HaxeError("Shader compilation error. " + "Shader file name: " + name);
		}
		return shader;
	}
	,getProgram: function(name) {
		var _this = this.programs;
		if(!(__map_reserved[name] != null ? _this.existsReserved(name) : _this.h.hasOwnProperty(name))) {
			throw new js__$Boot_HaxeError("The program hasn't been compiled yet. " + "Program name: " + name);
		}
		var _this1 = this.programs;
		if(__map_reserved[name] != null) {
			return _this1.getReserved(name);
		} else {
			return _this1.h[name];
		}
	}
};
var engine_input_Key = function(code) {
	this.previousState = engine_input_Key.KEY_UP;
	this.currentState = engine_input_Key.KEY_UP;
	this.nextState = engine_input_Key.KEY_UP;
	this.code = 0;
	this.code = code;
};
engine_input_Key.__name__ = true;
var engine_input_Keyboard = function(keys) {
	this.trackedKeyCodes = [];
	this.trackedKeys = new haxe_ds_IntMap();
	window.addEventListener("keydown",$bind(this,this.onKeyDown));
	window.addEventListener("keyup",$bind(this,this.onKeyUp));
	var _g = 0;
	while(_g < keys.length) {
		var key = keys[_g];
		++_g;
		this.trackedKeys.h[key.code] = key;
		this.trackedKeyCodes.push(key.code);
	}
};
engine_input_Keyboard.__name__ = true;
engine_input_Keyboard.prototype = {
	onKeyDown: function(event) {
		var key = this.trackedKeys.h[event.keyCode];
		if(key == null) {
			return;
		}
		key.nextState = engine_input_Key.KEY_DOWN;
	}
	,onKeyUp: function(event) {
		var key = this.trackedKeys.h[event.keyCode];
		if(key == null) {
			return;
		}
		key.nextState = engine_input_Key.KEY_UP;
	}
	,update: function() {
		var _g = 0;
		var _g1 = this.trackedKeyCodes;
		while(_g < _g1.length) {
			var code = _g1[_g];
			++_g;
			this.trackedKeys.h[code].previousState = this.trackedKeys.h[code].currentState;
			this.trackedKeys.h[code].currentState = this.trackedKeys.h[code].nextState;
		}
	}
	,dispose: function() {
		window.removeEventListener("keydown",$bind(this,this.onKeyDown));
		window.removeEventListener("keyup",$bind(this,this.onKeyUp));
		var _g = 0;
		var _g1 = this.trackedKeyCodes;
		while(_g < _g1.length) {
			var code = _g1[_g];
			++_g;
			this.trackedKeys.h[code].previousState = engine_input_Key.KEY_UP;
			this.trackedKeys.h[code].currentState = engine_input_Key.KEY_UP;
			this.trackedKeys.h[code].nextState = engine_input_Key.KEY_UP;
		}
	}
};
var engine_loop_GameLoop = function() {
	this.observer = null;
	this.shouldExitLoop = false;
};
engine_loop_GameLoop.__name__ = true;
engine_loop_GameLoop.prototype = {
	tick: function(timestamp) {
		if(this.shouldExitLoop) {
			return;
		}
		this.observer.update(timestamp);
		window.requestAnimationFrame($bind(this,this.tick));
	}
	,start: function(observer) {
		this.shouldExitLoop = false;
		this.observer = observer;
		this.tick(0);
	}
	,stop: function() {
		this.shouldExitLoop = true;
		this.observer = null;
	}
};
var engine_math_Vec2_$Float = function() { };
engine_math_Vec2_$Float.__name__ = true;
engine_math_Vec2_$Float.prototype = {
	add: function(x,y) {
	}
	,set: function(x,y) {
		this.x = x;
		this.y = y;
	}
};
var engine_math_Vec2Float = function() {
	this.x = 0;
	this.y = 0;
};
engine_math_Vec2Float.__name__ = true;
engine_math_Vec2Float.__super__ = engine_math_Vec2_$Float;
engine_math_Vec2Float.prototype = $extend(engine_math_Vec2_$Float.prototype,{
	add: function(x,y) {
		this.x += x;
		this.y += y;
	}
});
var engine_math_Vec2_$Int = function() { };
engine_math_Vec2_$Int.__name__ = true;
engine_math_Vec2_$Int.prototype = {
	set: function(x,y) {
		this.x = x;
		this.y = y;
	}
};
var engine_math_Vec2Int = function() {
	this.x = 0;
	this.y = 0;
};
engine_math_Vec2Int.__name__ = true;
engine_math_Vec2Int.__super__ = engine_math_Vec2_$Int;
engine_math_Vec2Int.prototype = $extend(engine_math_Vec2_$Int.prototype,{
});
var game_Config = function() { };
game_Config.__name__ = true;
var game_Glow = function() {
	this.isOutOfScreen = false;
	this.isExitIntersecting = false;
	this.bottomRightCornerPreviousCell = new engine_math_Vec2Int();
	this.bottomLeftCornerPreviousCell = new engine_math_Vec2Int();
	this.topRightCornerPreviousCell = new engine_math_Vec2Int();
	this.topLeftCornerPreviousCell = new engine_math_Vec2Int();
	this.bottomRightCornerCell = new engine_math_Vec2Int();
	this.bottomLeftCornerCell = new engine_math_Vec2Int();
	this.topRightCornerCell = new engine_math_Vec2Int();
	this.topLeftCornerCell = new engine_math_Vec2Int();
	this.position = new engine_math_Vec2Float();
	this.currentSpeed = new engine_math_Vec2Float();
	this.shape = new engine_graphics_Quad();
	this.shape.width = 20;
	this.shape.height = 20;
	this.shape.color = game_Config.GLOW_COLOR;
};
game_Glow.__name__ = true;
game_Glow.prototype = {
	moveHorizontally: function() {
		this.setPosition(this.position.x + this.currentSpeed.x,this.position.y);
	}
	,moveVertically: function() {
		this.setPosition(this.position.x,this.position.y + this.currentSpeed.y);
	}
	,setPosition: function(x,y) {
		var topLeftCornerCellx = this.topLeftCornerCell.x;
		var topLeftCornerCelly = this.topLeftCornerCell.y;
		var topRightCornerCelly = this.topRightCornerCell.y;
		var topRightCornerCellx = this.topRightCornerCell.x;
		var bottomLeftCornerCellx = this.bottomLeftCornerCell.x;
		var bottomLeftCornerCelly = this.bottomLeftCornerCell.y;
		var bottomRightCornerCellx = this.bottomRightCornerCell.x;
		var bottomRightCornerCelly = this.bottomRightCornerCell.y;
		this.position.set(x,y);
		this.shape.position = this.position;
		this.topLeftCornerCell.set(this.getColumn(this.position.x),this.getRow(this.position.y));
		this.topRightCornerCell.set(this.getColumn(this.position.x + 20 - 1),this.getRow(this.position.y));
		this.bottomLeftCornerCell.set(this.getColumn(this.position.x),this.getRow(this.position.y + 20 - 1));
		this.bottomRightCornerCell.set(this.getColumn(this.position.x + 20 - 1),this.getRow(this.position.y + 20 - 1));
		if(topLeftCornerCellx != this.topLeftCornerCell.x || topLeftCornerCelly != this.topLeftCornerCell.y) {
			this.topLeftCornerPreviousCell.set(topLeftCornerCellx,topLeftCornerCelly);
		}
		if(topRightCornerCelly != this.topRightCornerCell.y || topRightCornerCellx != this.topRightCornerCell.x) {
			this.topRightCornerPreviousCell.set(topRightCornerCellx,topRightCornerCelly);
		}
		if(bottomLeftCornerCellx != this.bottomLeftCornerCell.x || bottomLeftCornerCelly != this.bottomLeftCornerCell.y) {
			this.bottomLeftCornerPreviousCell.set(bottomLeftCornerCellx,bottomLeftCornerCelly);
		}
		if(bottomRightCornerCellx != this.bottomRightCornerCell.x || bottomRightCornerCelly != this.bottomRightCornerCell.y) {
			this.bottomRightCornerPreviousCell.set(bottomRightCornerCellx,bottomRightCornerCelly);
		}
		console.log("src/main/haxe/game/Glow.hx:77:","Cell previous " + this.bottomLeftCornerPreviousCell.y);
		console.log("src/main/haxe/game/Glow.hx:78:","Cell current " + this.bottomLeftCornerCell.y);
		console.log("src/main/haxe/game/Glow.hx:79:","Position " + this.position.y);
	}
	,isTop: function(cell) {
		if(cell != this.topLeftCornerCell) {
			return cell == this.topRightCornerCell;
		} else {
			return true;
		}
	}
	,isBottom: function(cell) {
		if(cell != this.bottomLeftCornerCell) {
			return cell == this.bottomRightCornerCell;
		} else {
			return true;
		}
	}
	,isRight: function(cell) {
		if(cell != this.bottomRightCornerCell) {
			return cell == this.topRightCornerCell;
		} else {
			return true;
		}
	}
	,isLeft: function(cell) {
		if(cell != this.bottomLeftCornerCell) {
			return cell == this.topLeftCornerCell;
		} else {
			return true;
		}
	}
	,getColumn: function(x) {
		return Math.floor(x / 20);
	}
	,getRow: function(y) {
		return Math.floor(y / 20);
	}
};
var game_Level = function() {
	this.glowPosition = new engine_math_Vec2Float();
	this.data = [];
	this.compositeShape = [];
	var stringData = engine_data_Data.getString("BlindLuck.lvl");
	var _g = 0;
	while(_g < 30) {
		var row = _g++;
		this.data.push([]);
		var _g1 = 0;
		while(_g1 < 40) {
			var column = _g1++;
			var char = stringData.charAt(row * 40 + column);
			var elementId = Std.parseInt(char);
			this.data[row].push(elementId);
		}
	}
	var _g11 = 0;
	var _g2 = this.data.length;
	while(_g11 < _g2) {
		var rowIndex = _g11++;
		var _g12 = 0;
		var _g21 = this.data[rowIndex].length;
		while(_g12 < _g21) {
			var columnIndex = _g12++;
			var positionX = columnIndex * 20;
			var positionY = rowIndex * 20;
			if(this.data[rowIndex][columnIndex] == 1 || this.data[rowIndex][columnIndex] == 2) {
				var rect = new engine_graphics_Quad();
				rect.position.set(positionX,positionY);
				rect.width = 20;
				rect.height = 20;
				if(this.data[rowIndex][columnIndex] == 1) {
					rect.color = game_Config.BRUSH_COLOR;
				}
				if(this.data[rowIndex][columnIndex] == 2) {
					rect.color = game_Config.EXIT_COLOR;
				}
				this.compositeShape.push(rect);
			}
			if(this.data[rowIndex][columnIndex] == 3) {
				this.glowPosition.set(columnIndex * 20,rowIndex * 20);
			}
		}
	}
};
game_Level.__name__ = true;
game_Level.prototype = {
	isCellValid: function(cell) {
		if(0 <= cell.y && cell.y < this.data.length && 0 <= cell.x) {
			return cell.x < this.data[cell.y].length;
		} else {
			return false;
		}
	}
	,getCellType: function(cell) {
		return this.data[cell.y][cell.x];
	}
};
var game_GameResult = $hxEnums["game.GameResult"] = { __ename__ : true, __constructs__ : ["Quit","Restart"]
	,Quit: {_hx_index:0,__enum__:"game.GameResult",toString:$estr}
	,Restart: {_hx_index:1,__enum__:"game.GameResult",toString:$estr}
};
var game_Main = function() { };
game_Main.__name__ = true;
game_Main.main = function() {
	game_Main.launch();
};
game_Main.launch = function() {
	new game_Game().run().then(function(result) {
		switch(result._hx_index) {
		case 0:
			window.alert("You won!");
			break;
		case 1:
			window.alert("You've lost. Try again!");
			game_Main.launch();
			break;
		}
	});
};
var game_Game = function() {
	this.gameResult = new lang_Promise();
	this.level = new game_Level();
	this.glow = new game_Glow();
	this.renderer = new engine_graphics_Renderer(800,600);
	this.keyboard = new engine_input_Keyboard([engine_input_Key.SPACE,engine_input_Key.RIGHT,engine_input_Key.LEFT]);
	this.loop = new engine_loop_GameLoop();
};
game_Game.__name__ = true;
game_Game.prototype = {
	run: function() {
		this.glow.setPosition(this.level.glowPosition.x,this.level.glowPosition.y);
		this.renderer.add([this.glow.shape]);
		this.renderer.add(this.level.compositeShape);
		this.loop.start(this);
		return this.gameResult;
	}
	,update: function(timestamp) {
		if(this.glow.isOutOfScreen) {
			this.stop(game_GameResult.Restart);
			return;
		}
		if(this.glow.isExitIntersecting) {
			this.stop(game_GameResult.Quit);
			return;
		}
		this.keyboard.update();
		this.glow.currentSpeed.add(0,1);
		if(engine_input_Key.RIGHT.currentState == engine_input_Key.KEY_DOWN) {
			this.glow.currentSpeed.set(1,this.glow.currentSpeed.y);
		} else if(engine_input_Key.LEFT.currentState == engine_input_Key.KEY_DOWN) {
			this.glow.currentSpeed.set(-1,this.glow.currentSpeed.y);
		} else {
			this.glow.currentSpeed.set(0,this.glow.currentSpeed.y);
		}
		if(engine_input_Key.SPACE.currentState == engine_input_Key.KEY_DOWN && engine_input_Key.SPACE.previousState == engine_input_Key.KEY_UP) {
			this.glow.currentSpeed.add(0,-15);
		}
		this.glow.moveHorizontally();
		this.checkIntersections(true);
		this.glow.moveVertically();
		this.checkIntersections(false);
		this.renderer.draw();
	}
	,checkIntersections: function(isHorizontal) {
		this.setGlowIntersections(this.glow.topLeftCornerCell,this.glow.topLeftCornerPreviousCell,isHorizontal);
		this.setGlowIntersections(this.glow.topRightCornerCell,this.glow.topRightCornerPreviousCell,isHorizontal);
		this.setGlowIntersections(this.glow.bottomRightCornerCell,this.glow.bottomRightCornerPreviousCell,isHorizontal);
		this.setGlowIntersections(this.glow.bottomLeftCornerCell,this.glow.bottomLeftCornerPreviousCell,isHorizontal);
	}
	,setGlowIntersections: function(cell,previousCell,isHorizontal) {
		if(this.level.isCellValid(cell)) {
			if(this.level.getCellType(cell) == 1) {
				if(isHorizontal) {
					if(cell.x > previousCell.x && this.glow.isRight(cell) || cell.x < previousCell.x && this.glow.isLeft(cell)) {
						this.glow.setPosition(previousCell.x * 20,this.glow.position.y);
					}
				} else if(cell.y < previousCell.y && this.glow.isTop(cell) || cell.y > previousCell.y && this.glow.isBottom(cell)) {
					this.glow.currentSpeed.set(this.glow.currentSpeed.x,0);
					this.glow.setPosition(this.glow.position.x,previousCell.y * 20);
				}
			} else if(this.level.getCellType(cell) == 2) {
				this.glow.isExitIntersecting = true;
			}
		} else {
			this.glow.isOutOfScreen = true;
		}
	}
	,stop: function(result) {
		this.loop.stop();
		this.renderer.dispose();
		this.keyboard.dispose();
		this.gameResult.resolve(result);
	}
};
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = true;
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.prototype = {
	setReserved: function(key,value) {
		if(this.rh == null) {
			this.rh = { };
		}
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) {
			return null;
		} else {
			return this.rh["$" + key];
		}
	}
	,existsReserved: function(key) {
		if(this.rh == null) {
			return false;
		}
		return this.rh.hasOwnProperty("$" + key);
	}
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var n = e.__constructs__[o._hx_index];
			var con = e[n];
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g3 = 0;
			var _g11 = o.length;
			while(_g3 < _g11) {
				var i = _g3++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e1 ) {
			var e2 = ((e1) instanceof js__$Boot_HaxeError) ? e1.val : e1;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str1 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str1.length != 2) {
			str1 += ", \n";
		}
		str1 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str1 += "\n" + s + "}";
		return str1;
	case "string":
		return o;
	default:
		return String(o);
	}
};
var js_html__$CanvasElement_CanvasUtil = function() { };
js_html__$CanvasElement_CanvasUtil.__name__ = true;
js_html__$CanvasElement_CanvasUtil.getContextWebGL = function(canvas,attribs) {
	var name = "webgl";
	var ctx = canvas.getContext(name,attribs);
	if(ctx != null) {
		return ctx;
	}
	var name1 = "experimental-webgl";
	var ctx1 = canvas.getContext(name1,attribs);
	if(ctx1 != null) {
		return ctx1;
	}
	return null;
};
var lang_Promise = function() {
	this.thenAction = function(result) {
	};
	this.isResolved = false;
};
lang_Promise.__name__ = true;
lang_Promise.prototype = {
	then: function(action) {
		this.thenAction = action;
		if(this.isResolved) {
			this.thenAction(this.resolvedResult);
		}
		return this;
	}
	,resolve: function(result) {
		this.thenAction(result);
		this.isResolved = true;
		this.resolvedResult = result;
		return this;
	}
};
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $global.$haxeUID++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = m.bind(o); o.hx__closures__[m.__id__] = f; } return f; }
$global.$haxeUID |= 0;
String.__name__ = true;
Array.__name__ = true;
var __map_reserved = {};
Object.defineProperty(js__$Boot_HaxeError.prototype,"message",{ get : function() {
	return String(this.val);
}});
js_Boot.__toStr = ({ }).toString;
engine_input_Key.KEY_DOWN = "KEY_DOWN";
engine_input_Key.KEY_UP = "KEY_UP";
engine_input_Key.SPACE = new engine_input_Key(32);
engine_input_Key.RIGHT = new engine_input_Key(39);
engine_input_Key.LEFT = new engine_input_Key(37);
game_Config.BRUSH_COLOR = engine_graphics_Color.get_RED();
game_Config.GLOW_COLOR = engine_graphics_Color.get_WHITE();
game_Config.EXIT_COLOR = engine_graphics_Color.get_YELLOW();
game_Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

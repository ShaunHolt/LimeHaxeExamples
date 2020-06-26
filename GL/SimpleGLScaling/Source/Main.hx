package;


import lime.app.Application;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.RenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.math.RGBA;
import lime.graphics.opengl.GLUniformLocation;

class Main extends Application {
		
	private var glVertexAttribute:Int;

	
	public function new () {
		
		super ();

		
	}
	
	
	public override function render (context:RenderContext):Void {
		
		switch (context.type) {
			
			
			case OPENGL, OPENGLES, WEBGL:


// Step1: Set OpenGL, OpenGLES, WebGL context
				
         var gl = context.webgl;


         /*===========Defining and storing the geometry==============*/
         var vertices =  [
            -0.5,0.5,0.0, 	
            -0.5,-0.5,0.0, 	
             0.5,-0.5,0.0,
            
         ];

         //Create an empty buffer object and store vertex data

         var vertex_buffer = gl.createBuffer();                                                     
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);                                                
         gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);           
         gl.bindBuffer(gl.ARRAY_BUFFER, null);  

         /*========================Shaders============================*/

         //Vertex shader source code
         var vertCode =
            'attribute vec4 coordinates;' + 
            'uniform mat4 u_xformMatrix;' +
            'void main(void) {' +
               '  gl_Position = u_xformMatrix * coordinates;' +
            '}';

         //Create a vertex shader program object and compile it                
         var vertShader = gl.createShader(gl.VERTEX_SHADER);
         gl.shaderSource(vertShader, vertCode);
         gl.compileShader(vertShader);

         //fragment shader source code
         var fragCode =
            'void main(void) {' +
               '   gl_FragColor = vec4(0.6, 0.7, 0.0, 0.1);' +
            '}';

         //Create a fragment shader program object and compile it 
         var fragShader = gl.createShader(gl.FRAGMENT_SHADER);
         gl.shaderSource(fragShader, fragCode);
         gl.compileShader(fragShader);

         //Create and use combiened shader program
         var shaderProgram = gl.createProgram();
         gl.attachShader(shaderProgram, vertShader);
         gl.attachShader(shaderProgram, fragShader);
         gl.linkProgram(shaderProgram);

         gl.useProgram(shaderProgram); 

         /*===================scaling==========================*/

         var Sx = 1.0, Sy = 1.5, Sz = 1.0;
         var xformMatrix = new Float32Array([
            Sx,   0.0,  0.0,  0.0,
            0.0,  Sy,   0.0,  0.0,
            0.0,  0.0,  Sz,   0.0,
            0.0,  0.0,  0.0,  1.0  
         ]);

         var u_xformMatrix = gl.getUniformLocation(shaderProgram, 'u_xformMatrix');
         gl.uniformMatrix4fv(u_xformMatrix, false, xformMatrix);

         /* ===========Associating shaders to buffer objects============*/
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);   

         var coordinatesVar = gl.getAttribLocation(shaderProgram, "coordinates"); 
         gl.vertexAttribPointer(coordinatesVar, 3, gl.FLOAT, false, 0, 0);  
         gl.enableVertexAttribArray(coordinatesVar);

         /*=================Drawing the Quad========================*/ 
         gl.clearColor(0.5, 0.5, 0.5, 0.9);
         gl.enable(gl.DEPTH_TEST);

         gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
         gl.viewport(0,0,window.width,window.height);
         gl.drawArrays(gl.TRIANGLES, 0, 3);
               
      


//      gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);

//      var vertices = [-0.5,-0.5, -0.25,0.5, 0.0,-0.5, 0.0,-0.5, 0.25,0.5, 0.5,-0.5,];
//      gl.drawArrays(gl.TRIANGLES, 0, 6);

//      var vertices = [-0.5,-0.5, -0.25,0.5, 0.0,-0.5,];
//      gl.drawArrays(gl.TRIANGLES, 0, 3);
					
			
			default:
			
		}
		
	}
	
	
}

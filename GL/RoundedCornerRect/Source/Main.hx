package;


import lime.app.Application;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.RenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;

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


         /*======= Defining and storing the geometry ======*/

         var vertices = [
//
             0,0,0,
            -0.35,-0.2,0,
             0.35,-0.2,0,
//
             0,0,0,
            -0.35,-0.2,0,
            -0.38,-0.18,0,
            
             0,0,0,
            -0.38,-0.18,0,
            -0.39,-0.16,0,

             0,0,0,
            -0.39,-0.16,0,
            -0.393,-0.14,0,

             0,0,0,
            -0.393,-0.14,0,
            -0.395,-0.12,0,

             0,0,0,
            -0.395,-0.12,0,
            -0.398,-0.1,0,
//
             0,0,0,
            -0.398,-0.1,0,
            -0.398,0.1,0, 
//
             0,0,0,
            -0.35,0.2,0,
            -0.38,0.18,0,
            
             0,0,0,
            -0.38,0.18,0,
            -0.39,0.16,0,

             0,0,0,
            -0.39,0.16,0,
            -0.393,0.14,0,

             0,0,0,
            -0.393,0.14,0,
            -0.395,0.12,0,

             0,0,0,
            -0.395,0.12,0,
            -0.398,0.1,0,
//
             0,0,0,
            -0.35,0.2,0,
             0.35,0.2,0,
//
             0,0,0,
             0.35,-0.2,0,
             0.38,-0.18,0,
            
             0,0,0,
             0.38,-0.18,0,
             0.39,-0.16,0,

             0,0,0,
             0.39,-0.16,0,
             0.393,-0.14,0,

             0,0,0,
             0.393,-0.14,0,
             0.395,-0.12,0,

             0,0,0,
             0.395,-0.12,0,
             0.398,-0.1,0,
//
             0,0,0,
             0.398,-0.1,0,
             0.398,0.1,0, 
//
             0,0,0,
             0.35,0.2,0,
             0.38,0.18,0,
            
             0,0,0,
             0.38,0.18,0,
             0.39,0.16,0,

             0,0,0,
             0.39,0.16,0,
             0.393,0.14,0,

             0,0,0,
             0.393,0.14,0,
             0.395,0.12,0,

             0,0,0,
             0.395,0.12,0,
             0.398,0.1,0
//
         ];
          
         // Create an empty buffer object
         var vertex_buffer = gl.createBuffer();

         // Bind appropriate array buffer to it
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);
      
         // Pass the vertex data to the buffer
         gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

         // Unbind the buffer
         gl.bindBuffer(gl.ARRAY_BUFFER, null);

         /*=================== Shaders ====================*/

         // Vertex shader source code
         var vertCode =
            'attribute vec3 coordinates;' +
            'void main(void) {' +
               ' gl_Position = vec4(coordinates, 1.0);' +
            '}';

         // Create a vertex shader object
         var vertShader = gl.createShader(gl.VERTEX_SHADER);

         // Attach vertex shader source code
         gl.shaderSource(vertShader, vertCode);

         // Compile the vertex shader
         gl.compileShader(vertShader);

         // Fragment shader source code
         var fragCode =
            'void main(void) {' +
               'gl_FragColor = vec4(0.6, 0.7, 0.0, 0.1);' +
            '}';

         // Create fragment shader object
         var fragShader = gl.createShader(gl.FRAGMENT_SHADER);

         // Attach fragment shader source code
         gl.shaderSource(fragShader, fragCode);

         // Compile the fragmentt shader
         gl.compileShader(fragShader);

         // Create a shader program object to store
         // the combined shader program
         var shaderProgram = gl.createProgram();

         // Attach a vertex shader
         gl.attachShader(shaderProgram, vertShader);

         // Attach a fragment shader
         gl.attachShader(shaderProgram, fragShader);

         // Link both the programs
         gl.linkProgram(shaderProgram);

         // Use the combined shader program object
         gl.useProgram(shaderProgram);

         /*======= Associating shaders to buffer objects ======*/

         // Bind vertex buffer object
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);

         // Get the attribute location
         var coord = gl.getAttribLocation(shaderProgram, "coordinates");

         // Point an attribute to the currently bound VBO
         gl.vertexAttribPointer(coord, 3, gl.FLOAT, false, 0, 0);

         // Enable the attribute
         gl.enableVertexAttribArray(coord);

         /*============ Drawing the triangle =============*/

         // Clear the canvas
         gl.clearColor(0.5, 0.5, 0.5, 0.9);

         // Enable the depth test
         gl.enable(gl.DEPTH_TEST);

         // Clear the color and depth buffer
         gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

         // Set the view port
         gl.viewport(0,0,window.width,window.height);

         // Draw the triangle
         gl.drawArrays(gl.TRIANGLES, 0, 72);

         // POINTS, LINE_STRIP, LINE_LOOP, LINES,
         // TRIANGLE_STRIP,TRIANGLE_FAN, TRIANGLES
      


					
			
			default:
			
		}
		
	}
	
	
}

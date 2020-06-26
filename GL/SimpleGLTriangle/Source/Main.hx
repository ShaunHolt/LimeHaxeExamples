package;


import lime.app.Application;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.RenderContext;
import lime.utils.Float32Array;


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



// Step2: Define the geometry and store it in buffer objects
					
         var vertices = [-0.5, 0.5, -0.5, -0.5, 0.0, -0.5, /*Mirror the tri*/  0.5, -0.5, 0.5, 0.5,0.5, 0.0];

         // Create a new buffer object
         var vertex_buffer = gl.createBuffer();

         // Bind an empty array buffer to it
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);
         
         // Pass the vertices data to the buffer
         gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

         // Unbind the buffer
         gl.bindBuffer(gl.ARRAY_BUFFER, null);



// Step3: Create and compile Shader programs


    // Vertex shader source code
         var vertCode =
            "attribute vec2 coordinates;
            void main(void) {gl_Position = vec4(coordinates,0.0, 1.0);}";

         //Create a vertex shader object
         var vertShader = gl.createShader(gl.VERTEX_SHADER);

         //Attach vertex shader source code
         gl.shaderSource(vertShader, vertCode);

         //Compile the vertex shader
         gl.compileShader(vertShader);
					


    //Fragment shader source code
         var fragCode = "void main(void) {gl_FragColor = vec4(0.1, 0.7, 0.0, 0.1);}";

         // Create fragment shader object
         var fragShader = gl.createShader(gl.FRAGMENT_SHADER);

         // Attach fragment shader source code
         gl.shaderSource(fragShader, fragCode);

         // Compile the fragment shader
         gl.compileShader(fragShader);



    // Create a shader program object to store combined shader program
         var shaderProgram = gl.createProgram();

         // Attach a vertex shader
         gl.attachShader(shaderProgram, vertShader); 
         
         // Attach a fragment shader
         gl.attachShader(shaderProgram, fragShader);

         // Link both programs
         gl.linkProgram(shaderProgram);

         // Use the combined shader program object
         gl.useProgram(shaderProgram);

					
// Step 4: Associate the shader programs to buffer objects

         //Bind vertex buffer object
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);

         //Get the attribute location
         var coord = gl.getAttribLocation(shaderProgram, "coordinates");

         //point an attribute to the currently bound VBO
         gl.vertexAttribPointer(coord, 2, gl.FLOAT, false, 0, 0);

         //Enable the attribute
         gl.enableVertexAttribArray(coord);
					
				
// Step5: Drawing the required object (triangle)


         // Clear the viewport
         gl.clearColor(0.6, 0.8, 0.5, 0.9);

         // Enable the depth test
         gl.enable(gl.DEPTH_TEST); 

         gl.clear(gl.DEPTH_BUFFER_BIT);        
         
         // Clear the color buffer bit
         gl.clear(gl.COLOR_BUFFER_BIT);

         // Set the view port
         gl.viewport(0,0,window.width,window.height);


// Draw the triangle
//         gl.drawArrays(gl.TRIANGLES, 0, 6);



      gl.drawArrays (gl.TRIANGLE_STRIP, 0, 6);

//      var vertices = [-0.5,-0.5, -0.25,0.5, 0.0,-0.5, 0.0,-0.5, 0.25,0.5, 0.5,-0.5,];
//      gl.drawArrays(gl.TRIANGLES, 0, 6);

//      var vertices = [-0.5,-0.5, -0.25,0.5, 0.0,-0.5,];
//      gl.drawArrays(gl.TRIANGLES, 0, 3);
					
			
			default:
			
		}
		
	}
	
	
}
